# Lab 04: Dissecting the Domain Name System (DNS)

## Overview
The Domain Name System (DNS) is a critical component of computer networks. In this lab, you’ll examine how DNS works by inspecting the DNS records for domains you (likely) use every day.

### Learning objectives
After completing this lab, you should be able to:
* Use `dig` to send and receive DNS queries and responses
* Use `tshark` to capture and inspect network packets
* Determine the addresses and/or aliases associated with a domain name (DN)
* Explain the steps required to obtain addresses and/or aliases for a DN
* Conduct simple network measurements involving DNS


## Getting started
Clone your git repository on a tigers server.

As you work on this lab, you may want to refer to the [class notes on DNS](https://docs.google.com/document/d/1Hw4gsG142lPyKLFF1DLgr0A0x021FhWIcpkmW1yUU1k/edit?usp=sharing).

You will need **three** terminal windows. You will run the following three commands (one in each terminal window) in the order listed below:

1. **`./docker_bind.sh BIND_PORT`** 

    replacing `BIND_PORT` with a randomly choosen port number between `5000` and `65000`; this will determine the port on which `bind`—a popular DNS application that functions as both a name server (NS) and a recursive resolver (RR)—listens for DNS queries.

2. **`./docker_exec.sh tshark -Odns udp and port 53 > packets.txt`**

    The command line arguments do the following:
        * `tshark` is the program to run within the Docker container
        * `-Odns` tells tshark to print out detailed information about the contents of DNS queries/responses
        * `udp and port 53` is a filter that tells tshark to only capture and analyze packets whose transport-layer protocol is the User Datagram Protocol (UDP) and whose source or destination port is 53 (the standard port for DNS) 
        * `> packets.txt` instructs the terminal to store the output from tshark into a file called `packets.txt`

3. **`dig @127.0.0.1 -p BIND_PORT +notcp www.colgate.edu A`**

    replacing `BIND_PORT` with the same value you used above. This command runs `dig` to issue a DNS query to `bind` for `A` records for [www.colgate.edu](www.colgate.edu). The command line arguments do the following:
        * `@127.0.0.1` tells dig to contact the RR running on the local machine (in a Docker container)
        * `-p BIND_PORT` tells dig to contact the RR on port `BIND_PORT`
        * `+notcp` tells dig to use UDP, instead of the Transmission Control Protocol (TCP), as the transport-layer protocol
        * `www.colgate.edu` is the domain name whose records are requested
        * `A` is the type of DNS records requested

**🛑 Answer the Getting Started questions in `questions.md`**

## Part 1: Record types
Your first task is to explore the different records associated with popular domains. You **only** need to run `bind` and `dig` for this part of the lab; you **do not** need to run `tshark`. Furthermore, you only need to start `bind` once, and let it continue to run until you are done with this part of the lab.

### Dig output
When you run `dig`, it provides lots of information about the DNS query and response. Below is a sample output from issuing a query for `A` records for `portal.colgate.edu`: 
```
; <<>> DiG 9.10.3-P4-Ubuntu &lt;<>> @localhost -p 8053 +notcp portal.colgate.edu A
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 54537
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 5, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;portal.colgate.edu.            IN      A

;; ANSWER SECTION:
portal.colgate.edu.     10555   IN      A       149.43.134.29

;; AUTHORITY SECTION:
colgate.edu.            170855  IN      NS      ns1.colgate.edu.
colgate.edu.            170855  IN      NS      ns3.colgate.edu.
colgate.edu.            170855  IN      NS      ns2.colgate.edu.
colgate.edu.            170855  IN      NS      ns4.colgate.edu.
colgate.edu.            170855  IN      NS      ns5.colgate.edu.

;; Query time: 0 msec
;; SERVER: 127.0.0.1#8053(127.0.0.1)
;; WHEN: Sat Feb 10 23:21:46 UTC 2024
;; MSG SIZE  rcvd: 153
```

The most pertinent parts of `dig`’s output are:
* **Question** section: This lists the domain name (DN) and record type for which a query was issued.
* **Answer** section: This lists the DNS records that matched the query. If this section is missing from the output, then no DNS records matched the query.
* **Authority** section: This lists the Name Servers (NS) that are the authoritative name servers for the DN, from whom the answer originated.

**🛑 Answer the Part 1 questions in `questions.md`**

## Part 2: Recursive resolvers
Your second task is to learn how DNS RRs work. As you work on this part of the lab, you must **restart bind at as instructed** to ensure you properly observe `bind`’s behavior.**

**Take the following actions now:**
1. Restart bind
2. Wait until bind outputs `running` 
3. Run `tshark`, using the redirection operator (`>`) to store its output in a file
4. Issue a DNS query for `A` records for `www.colgate.edu`
5. Kill `tshark` (using `Ctrl+c`)

### Tshark output
When you run `tshark` with the `-Odns` command-line argument, `tshark` provides lots of information about DNS queries and responses. Below is a sample of `tshark`’s output for the 3rd and 5th packets sent/received by `bind`. 

```
Frame 3: 98 bytes on wire (784 bits), 98 bytes captured (784 bits) on interface 0
Ethernet II, Src: 02:42:ac:11:00:02 (02:42:ac:11:00:02), Dst: 02:42:2f:02:af:ab (02:42:2f:02:af:ab)
Internet Protocol Version 4, Src: 172.17.0.2, Dst: 192.203.230.10
User Datagram Protocol, Src Port: 58125, Dst Port: 53
Domain Name System (query)
    Transaction ID: 0x2b2f
    Flags: 0x0010 Standard query
        0... .... .... .... = Response: Message is a query
        .000 0... .... .... = Opcode: Standard query (0)
        .... ..0. .... .... = Truncated: Message is not truncated
        .... ...0 .... .... = Recursion desired: Don't do query recursively
        .... .... .0.. .... = Z: reserved (0)
        .... .... ...1 .... = Non-authenticated data: Acceptable
    Questions: 1
    Answer RRs: 0
    Authority RRs: 0
    Additional RRs: 1
    Queries
        www.colgate.edu: type A, class IN
            Name: www.colgate.edu
            [Name Length: 15]
            [Label Count: 3]
            Type: A (Host Address) (1)
            Class: IN (0x0001)
    Additional records
        <Root>: type OPT
            Name: <Root>
            Type: OPT (41)
            UDP payload size: 512
            Higher bits in extended RCODE: 0x00
            EDNS0 version: 0
            Z: 0x8000
                1... .... .... .... = DO bit: Accepts DNSSEC security RRs
                .000 0000 0000 0000 = Reserved: 0x0000
            Data length: 12
            Option: COOKIE
                Option Code: COOKIE (10)
                Option Length: 8
                Option Data: 752b614353aadbb7
                Client Cookie: 752b614353aadbb7
                Server Cookie: <MISSING>

[Frame 4 excluded from sample output]

Frame 5: 309 bytes on wire (2472 bits), 309 bytes captured (2472 bits) on interface 0
Ethernet II, Src: 02:42:2f:02:af:ab (02:42:2f:02:af:ab), Dst: 02:42:ac:11:00:02 (02:42:ac:11:00:02)
Internet Protocol Version 4, Src: 192.203.230.10, Dst: 172.17.0.2
User Datagram Protocol, Src Port: 53, Dst Port: 58125
Domain Name System (response)
    Transaction ID: 0x2b2f
    Flags: 0x8200 Standard query response, No error
        1... .... .... .... = Response: Message is a response
        .000 0... .... .... = Opcode: Standard query (0)
        .... .0.. .... .... = Authoritative: Server is not an authority for domain
        .... ..1. .... .... = Truncated: Message is truncated
        .... ...0 .... .... = Recursion desired: Don't do query recursively
        .... .... 0... .... = Recursion available: Server can't do recursive queries
        .... .... .0.. .... = Z: reserved (0)
        .... .... ..0. .... = Answer authenticated: Answer/authority portion was not authenticated by the server
        .... .... ...0 .... = Non-authenticated data: Unacceptable
        .... .... .... 0000 = Reply code: No error (0)
    Questions: 1
    Answer RRs: 0
    Authority RRs: 13
    Additional RRs: 1
    Queries
        www.colgate.edu: type A, class IN
            Name: www.colgate.edu
            [Name Length: 15]
            [Label Count: 3]
            Type: A (Host Address) (1)
            Class: IN (0x0001)
    Authoritative nameservers
        edu: type NS, class IN, ns a.edu-servers.net
            Name: edu
            Type: NS (authoritative Name Server) (2)
            Class: IN (0x0001)
            Time to live: 172800
            Data length: 19
            Name Server: a.edu-servers.net
        edu: type NS, class IN, ns b.edu-servers.net
            Name: edu
            Type: NS (authoritative Name Server) (2)
            Class: IN (0x0001)
            Time to live: 172800
            Data length: 4
            Name Server: b.edu-servers.net
        edu: type NS, class IN, ns c.edu-servers.net
            Name: edu
            Type: NS (authoritative Name Server) (2)
            Class: IN (0x0001)
            Time to live: 172800
            Data length: 4
            Name Server: c.edu-servers.net
        edu: type NS, class IN, ns d.edu-servers.net
            Name: edu
            Type: NS (authoritative Name Server) (2)
            Class: IN (0x0001)
            Time to live: 172800
            Data length: 4
            Name Server: d.edu-servers.net
        edu: type NS, class IN, ns e.edu-servers.net
            Name: edu
            Type: NS (authoritative Name Server) (2)
            Class: IN (0x0001)
            Time to live: 172800
            Data length: 4
            Name Server: e.edu-servers.net
        edu: type NS, class IN, ns f.edu-servers.net
            Name: edu
            Type: NS (authoritative Name Server) (2)
            Class: IN (0x0001)
            Time to live: 172800
            Data length: 4
            Name Server: f.edu-servers.net
        edu: type NS, class IN, ns g.edu-servers.net
            Name: edu
            Type: NS (authoritative Name Server) (2)
            Class: IN (0x0001)
            Time to live: 172800
            Data length: 4
            Name Server: g.edu-servers.net
        edu: type NS, class IN, ns h.edu-servers.net
            Name: edu
            Type: NS (authoritative Name Server) (2)
            Class: IN (0x0001)
            Time to live: 172800
            Data length: 4
            Name Server: h.edu-servers.net
        edu: type NS, class IN, ns i.edu-servers.net
            Name: edu
            Type: NS (authoritative Name Server) (2)
            Class: IN (0x0001)
            Time to live: 172800
            Data length: 4
            Name Server: i.edu-servers.net
        edu: type NS, class IN, ns j.edu-servers.net
            Name: edu
            Type: NS (authoritative Name Server) (2)
            Class: IN (0x0001)
            Time to live: 172800
            Data length: 4
            Name Server: j.edu-servers.net
        edu: type NS, class IN, ns k.edu-servers.net
            Name: edu
            Type: NS (authoritative Name Server) (2)
            Class: IN (0x0001)
            Time to live: 172800
            Data length: 4
            Name Server: k.edu-servers.net
        edu: type NS, class IN, ns l.edu-servers.net
            Name: edu
            Type: NS (authoritative Name Server) (2)
            Class: IN (0x0001)
            Time to live: 172800
            Data length: 4
            Name Server: l.edu-servers.net
        edu: type NS, class IN, ns m.edu-servers.net
            Name: edu
            Type: NS (authoritative Name Server) (2)
            Class: IN (0x0001)
            Time to live: 172800
            Data length: 4
            Name Server: m.edu-servers.net
    Additional records
        <Root>: type OPT
            Name: <Root>
            Type: OPT (41)
            UDP payload size: 4096
            Higher bits in extended RCODE: 0x00
            EDNS0 version: 0
            Z: 0x8000
                1... .... .... .... = DO bit: Accepts DNSSEC security RRs
                .000 0000 0000 0000 = Reserved: 0x0000
            Data length: 0
    [Request In: 3]
    [Time: 0.008159539 seconds]
```

The 3rd packet is a DNS query for A records for www.colgate.edu. The query originated from a Docker container—Docker is configured to use IP addresses starting with `172.17.0`, except for `172.17.0.1`, which refers to the host operating system—and is destined for the NS whose IP address is `192.203.230.10`.

The 5th packet is a DNS response. The response originated from the NS whose IP address is `192.203.230.10` and is destined for a Docker container. The response contains the DNs of the NSes responsible for the root DNS zone.

### Reverse lookup
Although DNS is primarily used to lookup IP addresses and DN aliases associated with DNs, it is also capable of doing a reverse lookup: i.e., lookup the DN associated with an IP addressed.  To conduct a reverse lookup, include the `-x` command-line argument in the call to dig and specify `PTR` as the record type. For example:
```
	dig @localhost -p BIND_PORT +notcp -x 192.55.83.30 PTR
```
(Remember to **substitute** the port you used for `bind for `BIND_PORT`.)


**🛑 Answer the Part 2 questions in `questions.md`. You must restart `bind` when instructed to ensure you properly observe bind's behavior.**

## Self-assessment
The self-assessment for this lab will be available on Moodle next week. Please complete the self-assessment by 11pm on Tuesday, February 20.
