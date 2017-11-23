languageCode = "en-us"
title = "Escape"
baseURL = "https://escape.ankyra.io/"
pygmentsCodeFences = true
pygmentsStyle = "friendly"
pygmentsOptions = ""

[params]
    gaTrackingId = "UA-110134649-2"
    escapeClientVersion = "{{{escape_client_version}}}"
    escapeInventoryVersion = "{{{escape_inventory_version}}}"


[menu]
    [[menu.ankyra]]
    identifier = "home"
    name       = "Home"
    url        = "https://www.ankyra.io/"
    weight     = 1

    [[menu.ankyra]]
    identifier = "products"
    name       = "Products"
    url        = "/products/"
    weight     = 1

    [[menu.ankyra]]
    identifier = "team"
    name       = "Team"
    url        = "/team/"
    weight     = 2

    #[[menu.ankyra]]
    #identifier = "services"
    #name       = "Services"
    #url        = "#"
    #weight     = 3

    [[menu.ankyra]]
    identifier = "blog"
    name       = "Blog"
    url        = "/blog/"
    weight     = 4

    [[menu.ankyra]]
    name       = "Contact"
    pre        = "<i class='fa fa-envelope' aria-hidden='true'></i>&nbsp;"  
    url        = "https://www.ankyra.io/contact/"
    weight     = 5

    [[menu.ankyra]]
    name       = "Twitter"
    pre        = "<i class='fa fa-twitter' aria-hidden='true'></i>&nbsp;"  
    url        = "https://twitter.com/AnkyraLtd"
    weight     = 6

    [[menu.ankyra]]
    name       = "Github"
    pre        = "<i class='fa fa-github' aria-hidden='true'></i>&nbsp;"  
    url        = "https://github.com/Ankyra"
    weight     = 7

    [[menu.main]]
    identifier = "escape"
    name       = "Escape"
    pre        = ""  
    url        = "/docs/"
    weight     = 1

