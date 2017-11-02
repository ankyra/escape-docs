languageCode = "en-us"
title = "Escape"
baseURL = "https://www.ankyra.io"

[params]
    gaTrackingId = ""
    escapeClientVersion = "{{{escape_client_version}}}"
    escapeRegistryVersion = "{{{escape_inventory_version}}}"


[menu]
    [[menu.ankyra]]
    identifier = "home"
    name       = "Home"
    url        = "https://www.ankyra.io/"
    weight     = 1

    [[menu.ankyra]]
    identifier = "products"
    name       = "Products"
    url        = "https://www.ankyra.io/products/"
    weight     = 1

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
    url        = "https://www.ankyra.io/products/"
    weight     = 1

    [[menu.main]]
    identifier = "downloads"
    name       = "Downloads"
    pre        = ""  
    url        = "/downloads/"
    weight     = 2

    [[menu.main]]
    identifier = "docs"
    name       = "Docs"
    pre        = ""  
    url        = "/docs/"
    weight     = 3

    [[menu.main]]
    identifier = "app"
    name       = "Go to app"
    pre        = ""  
    url        = "/app/"
    weight     = 4
