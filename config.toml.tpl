languageCode = "en-us"
title = "Ankyra"
baseURL = "https://www.ankyra.io"

[params]
    gaTrackingId = ""
    escapeClientVersion = "{{{escape_client_version}}}"


[menu]
    [[menu.main]]
    identifier = "home"
    name       = "Home"
    url        = "/"
    weight     = 1

    [[menu.main]]
    identifier = "downloads"
    name       = "Downloads"
    url        = "/downloads/"
    weight     = 2

    [[menu.main]]
    identifier = "docs"
    name       = "Docs"
    url        = "/docs/"
    weight     = 3

    [[menu.main]]
    name       = "Github"
    pre        = "<i class='fa fa-github' aria-hidden='true'></i>&nbsp;"  
    url        = "https://github.com/Ankyra"
    weight     = 7
