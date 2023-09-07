---
layout: post
title: pen / ad / discov / bh
category: pen
parent: cheatsheets
modified_date: 2023-07-20
permalink: /pen/ad/discov/bh
---

**Menu**
<!-- vscode-markdown-toc -->
* [shoot](#shoot)
	* [shoot-forest](#shoot-forest)
	* [shoot-dom](#shoot-dom)
		* [shoot-pwd-notreqd](#shoot-pwd-notreqd)
		* [shoot-delegations](#shoot-delegations)
		* [shoot-priv-users](#shoot-priv-users)
		* [shoot-priv-machines](#shoot-priv-machines)
		* [shoot-shares](#shoot-shares)
		* [shoot-spns](#shoot-spns)
		* [shoot-mssql-servers](#shoot-mssql-servers)
		* [shoot-npusers](#shoot-npusers)
		* [shoot-dacl](#shoot-dacl)
	* [shoot-spfs](#shoot-spfs)
		* [shoot-gpos](#shoot-gpos)
		* [shoot-can-dcsync](#shoot-can-dcsync)
		* [shoot-dormant-accounts](#shoot-dormant-accounts)
		* [shoot-gpos](#shoot-gpos-1)
* [iter](#iter)
	* [iter-next-hops](#iter-next-hops)
	* [iter-sessions-da](#iter-sessions-da)
	* [iter-sessions-owned](#iter-sessions-owned)
	* [iter-memberof](#iter-memberof)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

**Must-watch**
* [Hausec Cypher Queries](https://hausec.com/2019/09/09/bloodhound-cypher-cheatsheet/)  
* [iccardo.ancarani94 tips](https://medium.com/@riccardo.ancarani94/bloodhound-tips-and-tricks-e1853c4b81ad) / 2019-08-11

## <a name='shoot'></a>shoot
### <a name='shoot-forest'></a>shoot-forest
```sh
# domain trusts
MATCH p=(n:Domain)-->(m:Domain) RETURN p
```
### <a name='shoot-dom'></a>shoot-dom
```sh
# show all domains and computers 
MATCH p = (d:Domain)-[r:Contains*1..]->(n:Computer) RETURN p

# show all users 
MATCH p = (d:Domain)-[r:Contains*1..]->(n:User) RETURN p

# overall map
MATCH q=(d:Domain)-[r:Contains*1..]->(n:Group)<-[s:MemberOf]-(u:User) RETURN q

```
#### <a name='shoot-pwd-notreqd'></a>shoot-pwd-notreqd
```sh
# NT hash for empty password: 31D6CFE0D16AE931B73C59D7E0C089C0
MATCH (n:User {enabled: True, passwordnotreqd: True}) RETURN n
```

#### <a name='shoot-delegations'></a>shoot-delegations
```sh
# find any computer that is NOT a domain controller and it is trusted to perform unconstrained delegation
MATCH (c1:Computer)-[:MemberOf*1..]->(g:Group) WHERE g.objectid ENDS WITH '-516' WITH COLLECT(c1.name) AS domainControllers MATCH (c2:Computer {unconstraineddelegation:true}) WHERE NOT c2.name IN domainControllers RETURN c2.name,c2.operatingsystem ORDER BY c2.name ASC

# find all computers with Unconstrained Delegation
MATCH (c:Computer {unconstraineddelegation:true}) return c

# display in BH a specific user with constrained deleg and his targets where he allowed to delegate
MATCH (u:User {name:'USER@DOMAIN.GR'}),(c:Computer),p=((u)-[r:AllowedToDelegate]->(c)) RETURN p


# find all users trusted to perform constrained delegation. The result is ordered by the amount of computers
MATCH (u:User)-[:AllowedToDelegate]->(c:Computer) RETURN u.name,COUNT(c) ORDER BY COUNT(c) DESC

# find users who are NOT marked as “Sensitive and Cannot Be Delegated” and have Administrative access to a computer, and where those users have sessions on servers with Unconstrained Delegation enabled (by NotMedic)   
MATCH (u:User {sensitive:false})-[:MemberOf*1..]->(:Group)-[:AdminTo]->(c1:Computer) WITH u,c1 MATCH (c2:Computer {unconstraineddelegation:true})-[:HasSession]->(u) RETURN u.name AS user,COLLECT(DISTINCT(c1.name)) AS AdminTo,COLLECT(DISTINCT(c2.name)) AS TicketLocation ORDER BY user ASC

# find users with constrained delegation permissions and the corresponding targets where they allowed to delegate
MATCH (u:User) WHERE u.allowedtodelegate IS NOT NULL RETURN u.name,u.allowedtodelegate

#Alternatively, search for users with constrained delegation permissions,the corresponding targets where they are allowed to delegate, the privileged users that can be impersonated (based on sensitive:false and admincount:true) and find where these users (with constrained deleg privs) have active sessions (user hunting) as well as count the shortest paths to them
OPTIONAL MATCH (u:User {sensitive:false, admincount:true}) WITH u.name AS POSSIBLE_TARGETS OPTIONAL MATCH (n:User) WHERE n.allowedtodelegate IS NOT NULL WITH n AS USER_WITH_DELEG, n.allowedtodelegate as DELEGATE_TO, POSSIBLE_TARGETS OPTIONAL MATCH (c:Computer)-[:HasSession]->(USER_WITH_DELEG) WITH USER_WITH_DELEG,DELEGATE_TO,POSSIBLE_TARGETS,c.name AS USER_WITH_DELEG_HAS_SESSION_TO OPTIONAL MATCH p=shortestPath((o)-[r:MemberOf|HasSession|AdminTo|AllExtendedRights|AddMember|ForceChangePassword|GenericAll|GenericWrite|Owns|WriteDacl|WriteOwner|CanRDP|ExecuteDCOM|AllowedToDelegate|ReadLAPSPassword|Contains|GpLink|AddAllowedToAct|AllowedToAct*1..]->(USER_WITH_DELEG)) WHERE NOT o=USER_WITH_DELEG WITH USER_WITH_DELEG,DELEGATE_TO,POSSIBLE_TARGETS,USER_WITH_DELEG_HAS_SESSION_TO,p RETURN USER_WITH_DELEG.name AS USER_WITH_DELEG, DELEGATE_TO, COLLECT(DISTINCT(USER_WITH_DELEG_HAS_SESSION_TO)) AS USER_WITH_DELEG_HAS_SESSION_TO, COLLECT(DISTINCT(POSSIBLE_TARGETS)) AS PRIVILEGED_USERS_TO_IMPERSONATE, COUNT(DISTINCT(p)) AS PATHS_TO_USER_WITH_DELEG

# find computers with constrained delegation permissions and the corresponding targets where they allowed to delegate
MATCH (c:Computer) WHERE c.allowedtodelegate IS NOT NULL RETURN c.name,c.allowedtodelegate

# Alternatively, search for computers with constrained delegation permissions, the corresponding targets where they are allowed to delegate, the privileged users that can be impersonated (based on sensitive:false and admincount:true) and find who is LocalAdmin on these computers as well as count the shortest paths to them:            
OPTIONAL MATCH (u:User {sensitive:false, admincount:true}) WITH u.name AS POSSIBLE_TARGETS OPTIONAL MATCH (n:Computer) WHERE n.allowedtodelegate IS NOT NULL WITH n AS COMPUTERS_WITH_DELEG, n.allowedtodelegate as DELEGATE_TO, POSSIBLE_TARGETS OPTIONAL MATCH (u1:User)-[:AdminTo]->(COMPUTERS_WITH_DELEG) WITH u1 AS DIRECT_ADMINS,POSSIBLE_TARGETS,COMPUTERS_WITH_DELEG,DELEGATE_TO OPTIONAL MATCH (u2:User)-[:MemberOf*1..]->(:Group)-[:AdminTo]->(COMPUTERS_WITH_DELEG) WITH COLLECT(DIRECT_ADMINS) + COLLECT(u2) AS TempVar,COMPUTERS_WITH_DELEG,DELEGATE_TO,POSSIBLE_TARGETS UNWIND TempVar AS LOCAL_ADMINS OPTIONAL MATCH p=shortestPath((o)-[r:MemberOf|HasSession|AdminTo|AllExtendedRights|AddMember|ForceChangePassword|GenericAll|GenericWrite|Owns|WriteDacl|WriteOwner|CanRDP|ExecuteDCOM|AllowedToDelegate|ReadLAPSPassword|Contains|GpLink|AddAllowedToAct|AllowedToAct*1..]->(COMPUTERS_WITH_DELEG)) WHERE NOT o=COMPUTERS_WITH_DELEG WITH COMPUTERS_WITH_DELEG,DELEGATE_TO,POSSIBLE_TARGETS,p,LOCAL_ADMINS RETURN COMPUTERS_WITH_DELEG.name AS COMPUTERS_WITH_DELG, LOCAL_ADMINS.name AS LOCAL_ADMINS_TO_COMPUTERS_WITH_DELG, DELEGATE_TO, COLLECT(DISTINCT(POSSIBLE_TARGETS)) AS PRIVILEGED_USERS_TO_IMPERSONATE, COUNT(DISTINCT(p)) AS PATHS_TO_USER_WITH_DELEG

```

#### <a name='shoot-priv-users'></a>shoot-priv-users
```sh
# show the privileged accounts graphs (per builtin group and per SID-RID)
# $builtin = @("Account Operators", "Domain Admins", "Administrators", "Server Operators", "DHCP Administrators", "Enterprise Admins", "Schema Admins", "DnsAdmins", "Group Policy Creator Owners", "Backup Operators", "Cert Publishers", "Event Log Readers", "Hyper-V Administrators", "Network Configuration Operators")


MATCH p = (m:Group {name: "ADMINISTRATORS@INTERNAL.LOCAL"})-[r:Contains*1..]->(n:User) RETURN p
MATCH p = (n:Group)<-[:MemberOf*1..]-(m) WHERE n.objectid =~ "(?i)S-1-5-.*-512" RETURN p

MATCH p = (m:Group {name: "BACKUP OPERATORS@INTERNAL.LOCAL"})-[r:Contains*1..]->(n:User) RETURN p
MATCH p = (n:Group)<-[:MemberOf*1..]-(m) WHERE n.objectid =~ "(?i)S-1-5-.*-512" RETURN p

MATCH p = (m:Group {name: "CERT PUBLISHERS@INTERNAL.LOCAL"})-[r:Contains*1..]->(n:User) RETURN p
MATCH p = (n:Group)<-[:MemberOf*1..]-(m) WHERE n.objectid =~ "(?i)S-1-5-.*-512" RETURN p

MATCH p = (m:Group {name: "DHCP ADMINISTRATORS@INTERNAL.LOCAL"})-[r:Contains*1..]->(n:User) RETURN p
MATCH p = (n:Group)<-[:MemberOf*1..]-(m) WHERE n.objectid =~ "(?i)S-1-5-.*-512" RETURN p

MATCH p = (m:Group {name: "DNSADMINS@INTERNAL.LOCAL"})-[r:Contains*1..]->(n:User) RETURN p
MATCH p = (n:Group)<-[:MemberOf*1..]-(m) WHERE n.objectid =~ "(?i)S-1-5-.*-512" RETURN p

MATCH p = (m:Group {name: "DOMAIN ADMINS@INTERNAL.LOCAL"})-[r:Contains*1..]->(n:User) RETURN p
MATCH p = (n:Group)<-[:MemberOf*1..]-(m) WHERE n.objectid =~ "(?i)S-1-5-.*-512" RETURN p

MATCH p = (m:Group {name: "ENTERPRISE ADMINS@INTERNAL.LOCAL"})-[r:Contains*1..]->(n:User) RETURN p
MATCH p = (n:Group)<-[:MemberOf*1..]-(m) WHERE n.objectid =~ "(?i)S-1-5-.*-512" RETURN p

MATCH p = (m:Group {name: "EVENT LOG READERS@INTERNAL.LOCAL"})-[r:Contains*1..]->(n:User) RETURN p
MATCH p = (n:Group)<-[:MemberOf*1..]-(m) WHERE n.objectid =~ "(?i)S-1-5-.*-512" RETURN p

MATCH p = (m:Group {name: "GROUP POLICY CREATOR OWNERS@INTERNAL.LOCAL"})-[r:Contains*1..]->(n:User) RETURN p
MATCH p = (n:Group)<-[:MemberOf*1..]-(m) WHERE n.objectid =~ "(?i)S-1-5-.*-512" RETURN p

MATCH p = (m:Group {name: "HYPER-V ADMINISTRATORS@INTERNAL.LOCAL"})-[r:Contains*1..]->(n:User) RETURN p
MATCH p = (n:Group)<-[:MemberOf*1..]-(m) WHERE n.objectid =~ "(?i)S-1-5-.*-512" RETURN p

MATCH p = (m:Group {name: "NETWORK CONFIGURATION OPERATORS"})-[r:Contains*1..]->(n:User) RETURN p
MATCH p = (n:Group)<-[:MemberOf*1..]-(m) WHERE n.objectid =~ "(?i)S-1-5-.*-512" RETURN p

MATCH p = (m:Group {name: "SCHEMA ADMINS@INTERNAL.LOCAL"})-[r:Contains*1..]->(n:User) RETURN p
MATCH p = (n:Group)<-[:MemberOf*1..]-(m) WHERE n.objectid =~ "(?i)S-1-5-.*-512" RETURN p

MATCH p = (m:Group {name: "SERVER OPERATORS@INTERNAL.LOCAL"})-[r:Contains*1..]->(n:User) RETURN p
MATCH p = (n:Group)<-[:MemberOf*1..]-(m) WHERE n.objectid =~ "(?i)S-1-5-.*-512" RETURN p


# show spf to builtin groups 
MATCH (n:User), (m:Group {name: "DOMAIN ADMINS@INTERNAL.LOCAL"}), p=shortestPath((n)-[*1..]->(m)) RETURN p
MATCH (n:User), (m:Group {name: "ADMINISTRATORS@INTERNAL.LOCAL"}), p=shortestPath((n)-[*1..]->(m)) RETURN p
MATCH (n:User), (m:Group {name: "SERVER OPERATORS@INTERNAL.LOCAL"}), p=shortestPath((n)-[*1..]->(m)) RETURN p
MATCH (n:User), (m:Group {name: "DHCP ADMINISTRATORES@INTERNAL.LOCAL"}), p=shortestPath((n)-[*1..]->(m)) RETURN p
MATCH (n:User), (m:Group {name: "ENTERPRISE ADMINS@INTERNAL.LOCAL"}), p=shortestPath((n)-[*1..]->(m)) RETURN p
MATCH (n:User), (m:Group {name: "SCHEMA ADMINS@INTERNAL.LOCAL"}), p=shortestPath((n)-[*1..]->(m)) RETURN p
MATCH (n:User), (m:Group {name: "DNSADMINS@INTERNAL.LOCAL"}), p=shortestPath((n)-[*1..]->(m)) RETURN p
MATCH (n:User), (m:Group {name: "GROUP POLICY CREATOR OWNERS@INTERNAL.LOCAL"}), p=shortestPath((n)-[*1..]->(m)) RETURN p
MATCH (n:User), (m:Group {name: "BACKUP OPERATORS@INTERNAL.LOCAL"}), p=shortestPath((n)-[*1..]->(m)) RETURN p
MATCH (n:User), (m:Group {name: "CERT PUBLISHERS@INTERNAL.LOCAL"}), p=shortestPath((n)-[*1..]->(m)) RETURN p
MATCH (n:User), (m:Group {name: "EVENT LOG READERS@INTERNAL.LOCAL"}), p=shortestPath((n)-[*1..]->(m)) RETURN p
MATCH (n:User), (m:Group {name: "HYPER-V ADMINISTRATORS@INTERNAL.LOCAL"}), p=shortestPath((n)-[*1..]->(m)) RETURN p
MATCH (n:User), (m:Group {name: "NETWORK CONFIGURATION OPERATORS"}), p=shortestPath((n)-[*1..]->(m)) RETURN p
MATCH (n:User), (m:Group {name: "DOMAIN ADMINS@INTERNAL.LOCAL"}), p=shortestPath((n)-[*1..]->(m)) RETURN p

# list the nodes prefixed with adm_
MATCH (n) WHERE n.name =~ “(?i)adm_.*” RETURN n LIMIT 10

# list the nodes with creation date
MATCH (n) WHERE n.cdate >= "" RETURN n LIMIT 10

# list the group with the word admin 
Match (n:Group) WHERE n.name CONTAINS "ADMIN" return n

# find a group with keywords. E.g. SQL ADMINS or SQL 2017 ADMINS      
MATCH (g:Group) WHERE g.name =~ '(?i).SQL.ADMIN.*' RETURN g
```

#### <a name='shoot-priv-machines'></a>shoot-priv-machines
```sh
# shoot-unsupported-os
MATCH p = (n:Computer) WHERE n.operatingsystem =~ "(?i).*(2000|2003|2008|xp|vista|7|me).*" RETURN n

# unconstrained delagation
MATCH (c:Computer {unconstraineddelegation:true}) return c
```
#### <a name='shoot-shares'></a>shoot-shares
#### <a name='shoot-spns'></a>shoot-spns
```sh
# has spn
MATCH (n:User)WHERE n.hasspn=true
RETURN n
# export it to graph.json, then list them
cat graph.json | jq -r 'nodes[].props.serviceprincipalnames | to_entries[] | .value' > spn.lst

# spn with passwords last set > 5 years ago       
MATCH (u:User) WHERE u.hasspn=true AND u.pwdlastset < (datetime().epochseconds - (1825 * 86400)) AND NOT u.pwdlastset IN [-1.0, 0.0]
RETURN u.name, u.pwdlastset order by u.pwdlastset

# kerberoastable users with path to DA
MATCH (u:User {hasspn:true}) MATCH (g:Group) WHERE g.name CONTAINS 'DOMAIN ADMINS' MATCH p = shortestPath( (u)-[*1..]->(g) ) RETURN p
```
#### <a name='shoot-mssql-servers'></a>shoot-mssql-servers
```sh
grep -i mssql spn.lst
```

#### <a name='shoot-npusers'></a>shoot-npusers
```sh
MATCH (u:User {dontreqpreauth: true}) RETURN u
```

#### <a name='shoot-dacl'></a>shoot-dacl
```sh
# find interesting privileges/ACEs that have been configured to DOMAIN USERS group
MATCH (m:Group) WHERE m.name =~ 'DOMAIN USERS@.*' MATCH p=(m)-[r:Owns|:WriteDacl|:GenericAll|:WriteOwner|:ExecuteDCOM|:GenericWrite|:AllowedToDelegate|:ForceChangePassword]->(n:Computer) RETURN p

# find all Edges that a specific user has against all the nodes (HasSession is not calculated, as it is an edge that comes from computer to user, not from user to computer)
MATCH (n:User) WHERE n.name =~ 'HELPDESK@DOMAIN.GR'MATCH (m) WHERE NOT m.name = n.name MATCH p=allShortestPaths((n)-[r:MemberOf|HasSession|AdminTo|AllExtendedRights|AddMember|ForceChangePassword|GenericAll|GenericWrite|Owns|WriteDacl|WriteOwner|CanRDP|ExecuteDCOM|AllowedToDelegate|ReadLAPSPassword|Contains|GpLink|AddAllowedToAct|AllowedToAct|SQLAdmin*1..]->(m)) RETURN p

# find all the Edges that any UNPRIVILEGED user (based on the admincount:False) has against all the nodes
MATCH (n:User {admincount:False}) MATCH (m) WHERE NOT m.name = n.name MATCH p=allShortestPaths((n)-[r:MemberOf|HasSession|AdminTo|AllExtendedRights|AddMember|ForceChangePassword|GenericAll|GenericWrite|Owns|WriteDacl|WriteOwner|CanRDP|ExecuteDCOM|AllowedToDelegate|ReadLAPSPassword|Contains|GpLink|AddAllowedToAct|AllowedToAct|SQLAdmin*1..]->(m)) RETURN p

# find interesting edges related to “ACL Abuse” that uprivileged users have against other users
MATCH (n:User {admincount:False}) MATCH (m:User) WHERE NOT m.name = n.name MATCH p=allShortestPaths((n)-[r:AllExtendedRights|ForceChangePassword|GenericAll|GenericWrite|Owns|WriteDacl|WriteOwner*1..]->(m)) RETURN p

# find interesting edges related to “ACL Abuse” that unprivileged users have against computers
MATCH (n:User {admincount:False}) MATCH p=allShortestPaths((n)-[r:AllExtendedRights|GenericAll|GenericWrite|Owns|WriteDacl|WriteOwner|AdminTo|CanRDP|ExecuteDCOM|ForceChangePassword*1..]->(m:Computer)) RETURN p

# find if unprivileged users have rights to add members into groups
MATCH (n:User {admincount:False}) MATCH p=allShortestPaths((n)-[r:AddMember*1..]->(m:Group)) RETURN p
```

### <a name='shoot-spfs'></a>shoot-spfs
```sh
# SPF to Domain Admins group from computers:          
MATCH (n:Computer),(m:Group {name:'DOMAIN ADMINS@DOMAIN.GR'}),p=shortestPath((n)-[r:MemberOf|HasSession|AdminTo|AllExtendedRights|AddMember|ForceChangePassword|GenericAll|GenericWrite|Owns|WriteDacl|WriteOwner|CanRDP|ExecuteDCOM|AllowedToDelegate|ReadLAPSPassword|Contains|GpLink|AddAllowedToAct|AllowedToAct*1..]->(m)) RETURN p

# SPF to Domain Admins group from computers excluding potential DCs (based on ldap/ and GC/ spns):              
WITH '(?i)ldap/.*' as regex_one WITH '(?i)gc/.*' as regex_two MATCH (n:Computer) WHERE NOT ANY(item IN n.serviceprincipalnames WHERE item =~ regex_two OR item =~ regex_two ) MATCH(m:Group {name:"DOMAIN ADMINS@DOMAIN.GR"}),p=shortestPath((n)-[r:MemberOf|HasSession|AdminTo|AllExtendedRights|AddMember|ForceChangePassword|GenericAll|GenericWrite|Owns|WriteDacl|WriteOwner|CanRDP|ExecuteDCOM|AllowedToDelegate|ReadLAPSPassword|Contains|GpLink|AddAllowedToAct|AllowedToAct*1..]->(m)) RETURN p

# SPF to Domain Admins group from all domain groups (fix-it):              
MATCH (n:Group),(m:Group {name:'DOMAIN ADMINS@DOMAIN.GR'}),p=shortestPath((n)-[r:MemberOf|HasSession|AdminTo|AllExtendedRights|AddMember|ForceChangePassword|GenericAll|GenericWrite|Owns|WriteDacl|WriteOwner|CanRDP|ExecuteDCOM|AllowedToDelegate|ReadLAPSPassword|Contains|GpLink|AddAllowedToAct|AllowedToAct*1..]->(m)) RETURN p

# SPF to Domain Admins group from non-privileged groups (AdminCount=false)              
MATCH (n:Group {admincount:false}),(m:Group {name:'DOMAIN ADMINS@DOMAIN.GR'}),p=shortestPath((n)-[r:MemberOf|HasSession|AdminTo|AllExtendedRights|AddMember|ForceChangePassword|GenericAll|GenericWrite|Owns|WriteDacl|WriteOwner|CanRDP|ExecuteDCOM|AllowedToDelegate|ReadLAPSPassword|Contains|GpLink|AddAllowedToAct|AllowedToAct*1..]->(m)) RETURN p

# SPF to Domain Admins group from the Domain Users group:              
MATCH (g:Group) WHERE g.name =~ 'DOMAIN USERS@.*' MATCH (g1:Group) WHERE g1.name =~ 'DOMAIN ADMINS@.*' OPTIONAL MATCH p=shortestPath((g)-[r:MemberOf|HasSession|AdminTo|AllExtendedRights|AddMember|ForceChangePassword|GenericAll|GenericWrite|Owns|WriteDacl|WriteOwner|CanRDP|ExecuteDCOM|AllowedToDelegate|ReadLAPSPassword|Contains|GpLink|AddAllowedToAct|AllowedToAct|SQLAdmin*1..]->(g1)) RETURN p
```

#### <a name='shoot-gpos'></a>shoot-gpos
```sh
# all gpos
Match (n:GPO) return n

# gpos with a keyword
Match (n:GPO) WHERE n.name CONTAINS "SERVER" return n
```
#### <a name='shoot-can-dcsync'></a>shoot-can-dcsync
```sh

```

#### <a name='shoot-dormant-accounts'></a>shoot-dormant-accounts

```sh
# pwdLastSet
```

* [Description](https://www.cert.ssi.gouv.fr/uploads/ad_checklist.html#vuln_user_accounts_dormant)


#### <a name='shoot-gpos-1'></a>shoot-gpos
```sh
### 
```

## <a name='iter'></a>iter

### <a name='iter-next-hops'></a>iter-next-hops
```sh
# find All edges any owned user has on a computer
MATCH p=shortestPath((m:User)-[r]->(b:Computer)) WHERE m.owned RETURN p

# find workstations a user can RDP into
match p=(g:Group)-[:CanRDP]->(c:Computer) where g.objectid ENDS WITH '-513'  AND NOT c.operatingsystem CONTAINS 'Server' return p


# find Servers a user can RDP into
match p=(g:Group)-[:CanRDP]->(c:Computer) where  g.objectid ENDS WITH '-513'  AND c.operatingsystem CONTAINS 'Server' return p   
```

### <a name='iter-sessions-da'></a>iter-sessions-da
```sh
# DA sessions not on a certain group (e.g. domain controllers)
OPTIONAL MATCH (c:Computer)-[:MemberOf]->(t:Group) WHERE NOT t.name = 'DOMAIN CONTROLLERS@TESTLAB.LOCAL' WITH c as NonDC MATCH p=(NonDC)-[:HasSession]->(n:User)-[:MemberOf]->(g:Group {name:”DOMAIN ADMINS@TESTLAB.LOCAL”}) RETURN DISTINCT (n.name) as Username, COUNT(DISTINCT(NonDC)) as Connexions ORDER BY COUNT(DISTINCT(NonDC)) DESC

# compute the DA session number
MATCH p=shortestPath((m:User)-[r:MemberOf*1..]->(n:Group {name: "DOMAIN ADMINS@INTERNAL.LOCAL"})) WITH m MATCH q=((m)<-[:HasSession]-(o:Computer)) RETURN count(o)

```

### <a name='iter-sessions-owned'></a>iter-sessions-owned
```sh
MATCH p=(m:Computer)-[r:HasSession]->(n:User {domain: "TEST.LOCAL"}) RETURN p
```

### <a name='iter-memberof'></a>iter-memberof
```sh
MATCH p=(n:User {name:"X@Y.COM"})-[r:MemberOf*1..]->(g:Group) RETURN p
```