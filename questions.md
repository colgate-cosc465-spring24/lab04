# Getting started
1. How would you change the command-line arguments for `dig` to tell dig to request the IPv6 address for `maps.google.com`? (Provide the full command you would execute.)


2. How would you change the command-line arguments for `dig` to use Google's public DNS RR instead of the bind RR you are running in Docker? Hint: see https://developers.google.com/speed/public-dns (Provide the full command you would execute.)


3. What protocol is running at each layer when you use dig to issue a DNS query? (Hint: see the output from `tshark`)
    * Link: 
    * Network: 
    * Transport: 
    * Application: 


# Part 1: Record types
1. What is the *IPv4* address for `portal.colgate.edu`?


2. What is the *IPv6* address for `portal.colgate.edu`?


3. What are the domain names (DNs) of the *authoritative name servers* (NSes) for `portal.colgate.edu`?


4. What are the DNs for the *email servers* responsible for emails sent to email addresses ending in `@colgate.edu`?


5. What is the *IPv4* address for one of Colgate's email servers?


6. What is the *IPv6* address for one of Colgate's email servers?


7. What are the DNs of the *authoritative NSes* for the DN of one of Colgate's email servers?


8. What DN is `moodle.colgate.edu` an alias for?


9. Based on this DN, where do you think Colgate's Moodle servers are located?


10. What is one of the *IPv4* address for the DN to which `moodle.colgate.edu` "redirects"?


# Part 2: Recursive resolvers
**Before you proceed:**
1. Restart bind
2. Wait until bind outputs `running`
3. Run tshark, storing its output in a file called `part2a.txt`
4. Issue a DNS query for A records for `www.colgate.edu`
5. Kill tshark (using Ctrl+c)

## Part 2a: DN resolution steps for www.colgate.edu
1. The 1st packet was sent from dig running in the host operating systems (172.17.0.1) to a Docker container (172.17.0.?). Is this a query or response?


2. How does the recursion desired flag on the 1st packet compare to the 2nd through 9th packets?


3. To whom was the 3rd packet sent? (Hint: conduct a reverse lookup on the destination IP address.)


4. What records did the previously listed NS send? (Hint: Look at the 4th or 5th packet. List the name, type, and value for each record included in the Answers and Authoritative nameservers sections. You can ignore OPT records.)


5. Whom did bind (running in the Docker container) contact next? (Hint: conduct a reverse lookup on the destination IP address.)


6. What records did the previously listed NS send? (List the name, type, and value for each record included in the Answers and Authoritative nameservers sections. You can ignore OPT, NSEC3, and RRSIG records.)


7. Whom did bind (running in the Docker container) contact next? (Hint: conduct a reverse lookup on the destination IP address.)


8. What records did the previously listed NS send? (List the name, type, and value for each record included in the Answers and Authoritative nameservers sections. You can ignore OPT records.)


9. The last (i.e., 10th) packet was sent from bind running in the Docker container to dig running in the host operating system (172.17.0.1). Is this a query or response?


10. What records does the last packet contain? (List the name, type, and value for each record included in the Answers and Authoritative nameservers sections. You can ignore OPT records.)


**Before you proceed:**
**Do not restart bind; it should still be running from Part 2a**
1. Run tshark
2. Issue a DNS query for A records for `portal.colgate.edu`
3. Kill tshark (using ctrl+c)

# Part 2b: Subsequent queries
1. To whom was the 2nd packet sent? (Hint: conduct a reverse lookup on the destination IP address.)


2. How is your answer to the previous question different from your answer to question 3 in Part 2a?


3. What does your answer to the previous question imply bind did with the records you listed in questions 4, 6, and 8 in Part 2a?


4. To whom do you expect bind to send queries if you used dig to issue a DNS
query for A records for `degreeworks.colgate.edu` (without restarting bind)?


5. Run tshark; issue a DNS query for A records for `degreeworks.colgate.edu`; kill tshark. How does the observed behavior (look at the output from tshark) compare to the expected behavior you specified in the previous question?


6. To whom do you expect bind to send queries if you used dig to issue a DNS query for A records for `www.hamilton.edu` (without restarting bind)?


7. Run tshark; issue a DNS query for A records for `www.hamilton.edu`; kill tshark. How does the observed behavior (look at the output from tshark) compare to the expected behavior you specified in the previous question?


