# Team members
* Your name
* Your partner's name

# Getting started
1. How would you change the command-line arguments for tshark to tell tshark to
only capture and analyze packets whose transport-layer protocol is the
Transmission Control Protocol (TCP) and whose source or destination port is
the standard port for HTTP? (Provide the full command you would execute.)


2. How would you change the command-line arguments for dig to tell dig to
request the IPv6 address for `maps.google.com`? (Provide the full command you
would execute.)


3. How would you change the command-line arguments for dig to use Google's
public DNS RR instead of the bind RR you are running in Docker? Hint: see
https://developers.google.com/speed/public-dns (Provide the full command you would execute.)


4. What protocol is running at each layer when you use dig to issue a DNS
query? (Hint: see the output from tshark)
Link: 
Network: 
Transport: 
Application: 


# Part 1: Record types
1. What is the *IPv4* address for `portal.colgate.edu`?


2. What is the *IPv6* address for `portal.colgate.edu`?


3. What are the domain names (DNs) of the *authoritative name servers* (NSes)
for `portal.colgate.edu`?


4. What are the DNs for the *email servers* responsible for emails sent to email
addresses ending in `@colgate.edu`?


5. What is the *IPv4* address for one of Colgate's email servers?


6. What is the *IPv6* address for one of Colgate's email servers?


7. What are the DNs of the *authoritative NSes* for the DN of one of Colgate's
email servers?


8. What DN is `moodle.colgate.edu` an alias for?


9. Based on this DN, where do you think Colgate's Moodle servers are located?


10. What is the *IPv4* address of the DN to which `moodle.colgate.edu` "redirects"?

11. What do `netflix.com`, `instagram.com`, and `nextdoor.com` have in common?


# Part 2: Recursive resolvers
*Before you proceed:*
1. Restart bind
2. Wait until bind outputs `running`
3. Run tshark
4. Issue a DNS query for A records for `www.colgate.edu`
5. Kill tshark (using ctrl+c)

## Part 2a: DN resolution steps for www.colgate.edu
1. The 1st packet was sent from dig running in the host operating systems
(172.0.0.1) to a Docker container (172.0.0.?). Is this a query or response?


2. How does the recursion desired flag on the 1st packet compare to the 2nd
through 9th packets?


3. To whom was the 3rd packet sent? (Hint: conduct a reverse lookup on the
destination IP address.)


4. What records did the previously listed NS send? (List the DN and type for
each record.)


5. Whom did bind (running in the Docker container) contact next? (Hint: conduct
a reverse lookup on the destination IP address.)


6. What records did the previously listed NS send? (List the DN and type for
each record.)


7. Whom did bind (running in the Docker container) contact next? (Hint: conduct
a reverse lookup on the destination IP address.)


8. What records did the previously listed NS send? (List the DN and type for
each record.)


9. The last (i.e., 10th) packet was sent from bind running in the Docker
container to dig running in the host operating system (172.0.0.1). Is this a
query or response?


10. What records does the last packet contain? (List the DN and type for each
record.)



*Before you proceed:*
1. Restart bind
2. Wait until bind outputs `running`
3. Run tshark without the `-c 1` command-line argument
4. Issue a DNS query for A records for `www.google.com`
5. Kill tshark (using ctrl+c)

## Part 2b: DN resolution steps for www.google.com
1. What are the source and destination of the 1st packet? (Provide a brief
description, *not* an IP address.)
From: 
To:

2. What are the key characteristics of the 1st packet? (Hint: Review questions 
1 and 2 in Part 2a.)


3. To whom was the 3rd packet sent? (Hint: conduct a reverse lookup on the
destination IP address.)


4. What records did the previously listed NS send? (List the DN and type for
each record.)


5. Whom did bind (running in the Docker container) contact next? (Hint: conduct
a reverse lookup on the destination IP address.)


6. What records did the previously listed NS send? (List the DN and type for
each record.)


7. Whom did bind (running in the Docker container) contact next? (Hint: conduct
a reverse lookup on the destination IP address.)


8. What records did the previously listed NS send? (List the DN and type for
each record.)


9. The last (i.e., 10th) packet was sent from bind running in the Docker
container to dig running in the host operating system (172.0.0.1). Is this a
query or response?


10. What records does the last packet contain? (List the DN and type for each
record.)


11. Review your answers to the questions in Part 2a and 2b. Briefly summarize
the steps taken by bind to lookup the A record for a DN.


*Before you proceed:*
*Do not restart bind; it should still be running from Part 2b*
1. Run tshark
2. Issue a DNS query for A records for `maps.google.com`
3. Kill tshark (using ctrl+c)

# Part 2c: Subsequent queries
1. To whom was the 2nd packet sent? (Hint: conduct a reverse lookup on the
destination IP address.)


2. How is your answer to the previous question different from your answer to
question 3 in Part 2b?


3. What does your answer to the previous question imply bind did with the
records you listed in questions 4, 6, and 8 in Part 2b?


4. To whom do you expect bind to send queries if you used dig to issue a DNS
query for A records for `drive.google.com` (without restarting bind)?


5. Run tshark; issue a DNS query for A records for `drive.google.com`; kill
tshark. How does the observed behavior (look at the output from tshark) compare
to the expected behavior you specified in the previous question?


6. To whom do you expect bind to send queries if you used dig to issue a DNS
query for A records for `www.ubuntu.com` (without restarting bind)?


7. Run tshark; issue a DNS query for A records for `www.ubuntu.com`; kill
tshark. How does the observed behavior (look at the output from tshark) compare
to the expected behavior you specified in the previous question?


