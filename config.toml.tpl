languageCode = "en-us"
title = "Escape"
baseURL = "https://escape.ankyra.io/"
pygmentsCodeFences = true
pygmentsStyle = "friendly"
pygmentsOptions = ""

[params]
    gaTrackingId = "{{google_analytics_id}}"
    escapeClientVersion = "{{{escape_client_version}}}"
    escapeInventoryVersion = "{{{escape_inventory_version}}}"


[menu]
    [[menu.ankyra]]
    identifier = "home"
    name       = "Home"
    url        = "https://www.ankyra.io/"
    weight     = 1

    [[menu.ankyra]]
    identifier = "docs"
    name       = "Docs"
    url        = "/docs/"
    weight     = 3

    [[menu.ankyra]]
    name       = "Contact"
    url        = "https://www.ankyra.io/#contact"
    weight     = 6

    [[menu.ankyra]]
    name       = "Follow us on Twitter"
    pre        = "<i class='fa fa-twitter' aria-hidden='true'></i>&nbsp;"  
    url        = "https://twitter.com/AnkyraLtd"
    weight     = 7
    target     = "_blank"

