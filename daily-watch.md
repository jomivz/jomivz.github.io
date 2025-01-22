---
layout: page
title: Cyber Watch
permalink: /watch
nav_order: 3
modified_date: 2024-09-09
---

## 👀 Daily Watch

* [CERT FR](https://www.cert.ssi.gouv.fr/)
* [cisa alerts](https://www.cisa.gov/news-events/cybersecurity-advisories?f%5B0%5D=advisory_type%3A94)
* DFIR Windows Bookmarks

[<img src="/assets/images/dashboard_dfir_win.png" />](https://start.me/p/KgoMGw/dfir-win)


## 👀 Github Watch

<script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
<script>$(window).load(function() {var repos = ["https://api.github.com/repos/lutzenfried/Methodology","https://github.com/vjeantet/hugo-theme-docdock","https://api.github.com/repos/swisskyrepo/PayloadsAllTheThings/","https://api.github.com/repos/snovvcrash/PPN","https://api.github.com/repos/mantvydasb/RedTeaming-Tactics-and-Techniques","https://api.github.com/repos/toolswatch/blackhat-arsenal-tools","https://api.github.com/repos/infosecn1nja/Red-Teaming-Toolkit","https://api.github.com/repos/bigb0sss/RedTeam-OffensiveSecurity","https://api.github.com/repos/S3cur3Th1sSh1t/Pentest-Tool","https://api.github.com/repos/certsocietegenerale/IRM","https://api.github.com/repos/elastic/protections-artifacts", "https://api.github.com/repos/A-poc/BlueTeam-Tools","https://api.github.com/repos/ekristen/cast"]; var repname = ["","","PayloadsAllTheThings","The PPN notebook", "ired.team"]; var replnk = ["","https://swisskyrepo.github.io/PayloadsAllTheThingsWeb/","https://ppn.snovvcrash.rocks/", "https://www.ired.team/", "https://github.com/mandiant/commando-vm","https://github.com/mandiant/flare-vm"]; for (rep in repos) {$.ajax({type: "GET", url: repos[rep], dataType: "json", success: function(result) {$("#repo_list").append("<tr><td><a href='" + result.html_url + "' target='_blank'>" + result.name + "</a></td><td>" + result.pushed_at + "</td><td>" + result.stargazers_count + "</td><td>" + result.subscribers_count + "</td>"); console.log(result);}});}console.log(result);});</script>

<link href="/sortable.css" rel="stylesheet" />
<script src="/sortable.js"></script>
<div id="repos">
    <table id="repo_list" class="sortable">
      <tr><th>_repo</th><th>_last_push</th><th>_stars</th><th>_watch</th></tr>
    </table>
</div>
