//
//  ARP.m
//  iOS MAC addr
//
//  Created by TUTU on 2017/2/28.
//  Copyright © 2017年 TUTU. All rights reserved.
//

#import "ARP.h"
#import "Address.h"
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <netinet/in.h>


#ifndef RTF_LLINFO
#define	RTF_LLINFO	0x400		/* generated by link layer (e.g. ARP) */
#endif /* RTF_LLINFO */

#ifndef RTM_GET
#define RTM_GET		0x4	/* Report Metrics */
#endif /* RTM_GET */

#ifndef RTA_DST
#define RTA_DST		0x1	/* destination sockaddr present */
#endif /* RTA_DST */

#ifdef RTM_VERSION
#undef RTM_VERSION
#endif /*  RTM_VERSION */
#define RTM_VERSION	5	// important, version 2 won't work

#define BUFLEN (sizeof(struct rt_msghdr) + 512)

/* copy from net/route.h */
#ifndef _NET_ROUTE_H_
/*
 * These numbers are used by reliable protocols for determining
 * retransmission behavior and are included in the routing structure.
 */
#if TARGET_IPHONE_SIMULATOR
#else
struct rt_metrics {
    u_int32_t	rmx_locks;	/* Kernel leaves these values alone */
    u_int32_t	rmx_mtu;	/* MTU for this path */
    u_int32_t	rmx_hopcount;	/* max hops expected */
    int32_t		rmx_expire;	/* lifetime for route, e.g. redirect */
    u_int32_t	rmx_recvpipe;	/* inbound delay-bandwidth product */
    u_int32_t	rmx_sendpipe;	/* outbound delay-bandwidth product */
    u_int32_t	rmx_ssthresh;	/* outbound gateway buffer limit */
    u_int32_t	rmx_rtt;	/* estimated round trip time */
    u_int32_t	rmx_rttvar;	/* estimated rtt variance */
    u_int32_t	rmx_pksent;	/* packets sent using this route */
    u_int32_t	rmx_filler[4];	/* will be used for T/TCP later */
};

/*
 * Structures for routing messages.
 */
struct rt_msghdr {
    u_short	rtm_msglen;	/* to skip over non-understood messages */
    u_char	rtm_version;	/* future binary compatibility */
    u_char	rtm_type;	/* message type */
    u_short	rtm_index;	/* index for associated ifp */
    int	rtm_flags;	/* flags, incl. kern & message, e.g. DONE */
    int	rtm_addrs;	/* bitmask identifying sockaddrs in msg */
    pid_t	rtm_pid;	/* identify sender */
    int	rtm_seq;	/* for sender to identify action */
    int	rtm_errno;	/* why failed */
    int	rtm_use;	/* from rtentry */
    u_int32_t rtm_inits;	/* which metrics we are initializing */
    struct rt_metrics rtm_rmx; /* metrics themselves */
};

#endif

#endif /* _NET_ROUTE_H_ */

/* copy from netinet/if_ether.h */
#ifndef _NETINET_IF_ETHER_H_
struct sockaddr_inarp {
    u_char	sin_len;
    u_char	sin_family;
    u_short sin_port;
    struct	in_addr sin_addr;
    struct	in_addr sin_srcaddr;
    u_short	sin_tos;
    u_short	sin_other;
#define	SIN_PROXY	0x1
#define	SIN_ROUTER	0x2
};
#endif /* _NETINET_IF_ETHER_H_ */

#ifndef SA_SIZE
#define SA_SIZE(sa)                                             \
(  (!(sa) || ((struct sockaddr *)(sa))->sa_len == 0) ?      \
sizeof(uint32_t)            :                               \
1 + ( (((struct sockaddr *)(sa))->sa_len - 1) | (sizeof(uint32_t) - 1) ) )
#endif

@implementation ARP
#if TARGET_IPHONE_SIMULATOR
#else
+ (nullable NSString *)walkMACAddressOf: (nonnull NSString *)ipAddress {
    int mib[6];
    size_t needed;
    char *lim, *buf, *newbuf, *next;
    struct rt_msghdr *rtm;
    struct sockaddr_inarp *sin2;
    struct sockaddr_dl *sdl;
    int st;
    
    mib[0] = CTL_NET;
    mib[1] = PF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_INET;
    mib[4] = NET_RT_FLAGS;
    mib[5] = RTF_LLINFO;
    if(sysctl(mib, 6, NULL, &needed, NULL, 0) < 0) {
        perror("sysctl()");
        return nil;
    }//end if
    
    if(needed == 0) { /* empty table */
        return nil;
    }
    
    buf = NULL;
    for(;;) {
        newbuf = realloc(buf, needed);
        if(newbuf == NULL) {
            perror("realloc()");
            if(buf != NULL) {
                free(buf);
            }//end if
            return nil;
        }//end if
        buf = newbuf;
        st = sysctl(mib, 6, buf, &needed, NULL, 0);
        if(st == 0 || errno != ENOMEM)
            break;
        needed += needed / 8;
    }//end for
    
    NSString *macAddress = nil;
    in_addr_t searchIpAddress = [Address IPv4Pton:ipAddress];
    
    lim = buf + needed;
    for(next = buf; next < lim; next += rtm->rtm_msglen) {
        rtm = (struct rt_msghdr *)next;
        sin2 = (struct sockaddr_inarp *)(rtm + 1);
        sdl = (struct sockaddr_dl *)((char *)sin2 + SA_SIZE(sin2));
        if(searchIpAddress == sin2->sin_addr.s_addr) {
            macAddress = [Address linkLayerNtop:sdl];
            break;
        }//end if found
    }//end for
    free(buf);
    
    return macAddress;
}//end walkMACAddressOf:


+ (nullable NSString *)MACAddressOf: (nonnull NSString *)ipAddress {
    static int seq = 0;
    int sockfd = socket(AF_ROUTE, SOCK_RAW, 0);
    if(sockfd < 0) {
        perror("socket()");
        return nil;
    }//end if
    
    unsigned char buf[BUFLEN];
    
    //rtm message buffer
    memset(buf, 0, sizeof(buf));
    struct rt_msghdr *rtm = (struct rt_msghdr *)buf;
    rtm->rtm_msglen = sizeof(struct rt_msghdr) + sizeof(struct sockaddr_in);
    rtm->rtm_version = RTM_VERSION;
    rtm->rtm_type = RTM_GET;
    rtm->rtm_addrs = RTA_DST;
    rtm->rtm_flags = RTF_LLINFO;
    rtm->rtm_pid = getpid();
    rtm->rtm_seq = ++seq;
    
    //socket address
    struct sockaddr_in *sin = (struct sockaddr_in *)(rtm + 1);
    sin->sin_len = sizeof(struct sockaddr_in);
    sin->sin_family = AF_INET;
    sin->sin_addr.s_addr = [Address IPv4Pton:ipAddress];
    
    //send message
    write(sockfd, rtm, rtm->rtm_msglen);
    
    ssize_t n = read(sockfd, buf, BUFLEN);
    close(sockfd);
    
    if(n < 0) {
        perror("read()");
        return nil;
    }//end if
    
    NSString *macAddress = nil;
    if (n != 0) {
        struct sockaddr_dl *sdl = (struct sockaddr_dl *)(buf + sizeof(struct rt_msghdr) + sizeof(struct sockaddr_inarp));
        macAddress = [Address linkLayerNtop:sdl];
    }//end if
    return macAddress;
}//end MACAddressOf:
#endif
@end
