workspace {
    !docs workspace-docs

    model {
        reader = person "Reader" "User of the E-Library System"
        administrator = person "Administrator" "Admin allowed to add items to the library, manage accounts and financial transactions"
        enterprise "E-Library System" {
            accounts = softwareSystem "Accounts" "Allows customers to create, view details, and update accounts." {
                accountsSpa = container "Accounts Single Page Application" "Presents account view, allows use of account functionality from UI" "React Component"
                accountMicroservice = container "Accounts Microservice" "Exposes API for account functionality" "Java and Spring Boot"
                accountDatabase = container "Accounts Database" "Stores user accounts" "MongoDB" "Database"
                !docs accounts/docs
            }
            shelf = softwareSystem "Shelf" "Stores and presents user-borrowed items" {
                shelfSinglePageApplication = container "Shelf Single Page Application" "Presents shelf view, allows use of shelf functionality from UI" "React Component"
                shelfMicroservice = container "Shelf Microservice" "Exposes API for shelf functionality" "Java and Spring Boot"
                shelfDatabase = container "Shelf Database" "Stores user-borrowed items" "MongoDB" "Database"
                !docs shelf/docs

            }
            products = softwareSystem "Products" "Stores and presents items in the library" {
                productsSinglePageApplication = container "Products Single Page Application" "Presents products view, allows use of products functionality from UI" "React Component"
                productsMicroservice = container "Products Microservice" "Exposes API for products functionality" "Java and Spring Boot"
                productsDatabase = container "Products Database" "Stores items in the library" "MongoDB" "Database"
                !docs products/docs
            }
            cart = softwareSystem "Cart" "Manages item rental process" {
                cartSinglePageApplication = container "Cart Single Page Application" "Presents cart view, allows use of cart functionality from UI" "React Component"
                cartMicroservice = container "Cart Microservice" "Exposes API for cart functionality" "Java and Spring Boot"
                cartDatabase = container "Cart Database" "Stores items in the cart" "MongoDB" "Database"
                !docs cart/docs
            }
            recommendations = softwareSystem "Recommendations" "Stores and presents recommended items for the reader" {
                recommendationSinglePageApplication = container "Recommendations Single Page Application" "Presents recommendations view, allows use of recommendations functionality from UI" "React Component"
                recommendationMicroservice = container "Recommendations Microservice" "Exposes API for recommendations functionality" "Java and Spring Boot"
                recommendationDatabase = container "Recommendations Database" "Stores recommended items for the reader" "MongoDB" "Database"
                !docs recommendations/docs
            }
            finance = softwareSystem "Finance" "Manages financial transactions and payment processes" {
                financeSinglePageApplication = container "Finance Single Page Application" "Presents finance view, allows use of finance functionality from UI" "React Component"
                financeMicroservice = container "Finance Microservice" "Exposes API for finance functionality" "Java and Spring Boot"
                financeDatabase = container "Finance Database" "Stores financial transactions" "PostgreSQL" "Database"
                !docs finance/docs
            }
        }

        mail = softwareSystem "Mail Provider" "Sends emails" "External System"

        // Define system relationships
        reader -> accounts "Manages user accounts"
        reader -> shelf "Manages user-borrowed items"
        reader -> products "Presents available items for rental"
        reader -> cart "Manages item rental process"
        reader -> recommendations "Manages reader recommendations"

        reader -> finance "Manages user financial transactions"

        cart -> finance "Manage cart payments"

        administrator -> accounts "Manages user accounts"
        administrator -> products "Manages items in the library"
        administrator -> finance "Oversees financial transactions"

        mail -> reader "Sends invoice"

        // Define container relationships
        reader -> accountsSpa "Manages user accounts"
        reader -> shelfSinglePageApplication "Manages user-borrowed items"
        reader -> productsSinglePageApplication "Presents available items for rental"
        reader -> cartSinglePageApplication "Manages item rental process"
        reader -> recommendationSinglePageApplication "Gets recommendations"
        reader -> financeSinglePageApplication "Performs payments"

        administrator -> productsSinglePageApplication "Manages items in the library"
        administrator -> financeSinglePageApplication "Oversees financial transactions"
        administrator -> accountsSpa "Manages user accounts"

        accountsSpa -> accountMicroservice "Requests account operations" "HTTPS"
        accountMicroservice -> accountDatabase "Stores and fetches user accounts" "JDBC"
        accountMicroservice -> recommendationMicroservice "Stores user recommendations" "Kafka"

        shelfSinglePageApplication -> shelfMicroservice "Requests shelf operations" "HTTPS"
        shelfMicroservice -> shelfDatabase "Stores and fetches user-borrowed items" "JDBC"

        productsSinglePageApplication -> productsMicroservice "Requests product operations" "HTTPS"
        productsMicroservice -> productsDatabase "Stores and fetches items in the library" "JDBC"

        cartSinglePageApplication -> cartMicroservice "Requests cart operations" "HTTPS"
        cartMicroservice -> cartDatabase "Stores and fetches items in the cart" "JDBC"
        cartMicroservice -> recommendationMicroservice "Notifies about added items to cart by user" "Kafka"
        cartMicroservice -> shelfMicroservice "Notifies about borrowed items by user" "Kafka"
        cartMicroservice -> productsMicroservice "Checks product availability" "HTTPS"
        cartMicroservice -> financeMicroservice "Generate payment link" "HTTPS"
        cartMicroservice -> financeMicroservice "Manage cart payments" "Kafka"

        recommendationSinglePageApplication -> recommendationMicroservice "Requests recommendations operations" "HTTPS"
        recommendationMicroservice -> recommendationDatabase "Stores and fetches user recommendations" "JDBC"

        financeSinglePageApplication -> financeMicroservice "Requests finance operations" "HTTPS"
        financeMicroservice -> financeDatabase "Stores and fetches financial transactions" "JDBC"
        financeMicroservice -> mail "Sends emails with invoices to readers" "SMTP"
    }
    views {
        properties {
            "generatr.style.colors.primary" "#2196f3"
            "generatr.style.colors.secondary" "#ffffff"
            "generatr.style.faviconPath" "site/favicon.ico"
            "generatr.style.logoPath" "site/logo.png"
            "generatr.style.customStylesheet" "site/custom.css"
            "generatr.svglink.target" "_self"
            "generatr.markdown.flexmark.extensions" "Abbreviation,Admonition,AnchorLink,Attributes,Autolink,Definition,Emoji,Footnotes,GfmTaskList,GitLab,MediaTags,Tables,TableOfContents,Typographic"
            "c4plantuml.elementProperties" "true"
            "c4plantuml.tags" "true"
        }

        systemLandscape "SystemLandscape" {
            include *
            autolayout
        }

        systemContext accounts {
            include *
            autolayout lr
        }

        systemContext shelf {
            include *
            autolayout lr
        }

        systemContext products {
            include *
            autolayout lr
        }

        systemContext cart {
            include *
            autolayout lr
        }

        systemContext recommendations {
            include *
            autolayout lr
        }

        systemContext finance {
            include *
            autolayout lr
        }

        container accounts {
            include *
            autolayout lr
        }

        container shelf {
            include *
            autolayout lr
        }

        container products {
            include *
            autolayout lr
        }

        container cart {
            include *
            autolayout lr
        }

        container recommendations {
            include *
            autolayout lr
        }

        container finance {
            include *
            autolayout lr

        }
        // Dynamic View: Reader Registration
        dynamic accounts "reader-registration" "Reader Registration" {
            reader -> accountsSpa "Registers new account"
            accountsSpa -> accountMicroservice "Requests account creation" "HTTPS"
            accountMicroservice -> accountDatabase "Stores new account" "JDBC"
            accountDatabase -> accountMicroservice "Returns created account" "JDBC"
            accountMicroservice -> recommendationMicroservice "Stores user recommendations" "Kafka"
            recommendationMicroservice -> accountMicroservice "Recieves user recommendations" "Kafka"
            accountMicroservice -> accountsSpa "Returns created account" "HTTPS"
            accountsSpa -> reader "Returns created account"
            autolayout lr
        }

        // Dynamic View: Add books to shelf
        dynamic shelf "add-books-to-shelf" "Add books to shelf" {
            cartMicroservice -> shelfMicroservice "Notifies about borrowed items by user" "Kafka"
            shelfMicroservice -> cartMicroservice "Request accepted" "Kafka"
            shelfMicroservice -> shelfDatabase "Stores borrowed items" "JDBC"
            shelfDatabase -> shelfMicroservice "Returns store result" "JDBC"

            autolayout rl
        }

        // Dynamic View: Present books from reader shelf
        dynamic shelf "present-books-from-reader-shelf" "Present books from reader shelf" {
            reader -> shelfSinglePageApplication "Requests shelf view"
            shelfSinglePageApplication -> shelfMicroservice "Requests shelf items" "HTTPS"
            shelfMicroservice -> shelfDatabase "Fetches shelf items" "JDBC"
            shelfDatabase -> shelfMicroservice "Returns fetched items" "JDBC"
            shelfMicroservice -> shelfSinglePageApplication "Returns fetched items" "HTTPS"
            shelfSinglePageApplication -> reader "Presents shelf view"
            autolayout rl
        }

        // Dynamic View: Add book to library
        dynamic products "add-book-to-library" "Add book to library" {
            administrator -> productsSinglePageApplication "Adds new book"
            productsSinglePageApplication -> productsMicroservice "Adds new book" "HTTPS"
            productsMicroservice -> productsDatabase "Stores new product" "JDBC"
            productsDatabase -> productsMicroservice "Returns store result" "JDBC"
            productsMicroservice -> productsSinglePageApplication "Returns new book id" "HTTPS"
            productsSinglePageApplication -> administrator "Presents details of added book"
            autolayout lr
        }

        // Dynamic View: remove book from library
        dynamic products "remove-book-from-library" "Remove book from library" {
            administrator -> productsSinglePageApplication "Removes book"
            productsSinglePageApplication -> productsMicroservice "Removes book" "HTTPS"
            productsMicroservice -> productsDatabase "Removes product" "JDBC"
            productsDatabase -> productsMicroservice "Returns remove result" "JDBC"
            productsMicroservice -> productsSinglePageApplication "Returns remove result" "HTTPS"
            productsSinglePageApplication -> administrator "Presents details of removed book"
            autolayout lr
        }

        // Dynamic View: present available books
        dynamic products "present-available-books" "Present available books" {
            reader -> productsSinglePageApplication "Requests available books"
            productsSinglePageApplication -> productsMicroservice "Requests available books" "HTTPS"
            productsMicroservice -> productsDatabase "Fetches available books" "JDBC"
            productsDatabase -> productsMicroservice "Returns fetched books" "JDBC"
            productsMicroservice -> productsSinglePageApplication "Returns fetched books" "HTTPS"
            productsSinglePageApplication -> reader "Presents available books"
            autolayout lr
        }

        dynamic recommendations "present-recommended-products" "Present recommended products" {
            reader -> recommendationSinglePageApplication "Present recommended products"
            recommendationSinglePageApplication -> recommendationMicroservice "Requests recommended products" "HTTPS"
            recommendationMicroservice -> recommendationDatabase "Fetches recommended products" "JDBC"
            recommendationDatabase -> recommendationMicroservice "Returns fetched products" "JDBC"
            recommendationMicroservice -> recommendationSinglePageApplication "Returns fetched products" "HTTPS"
            recommendationSinglePageApplication -> reader "Presents recommended products"
            autolayout lr
        }

        //Dynamic View: update user recomendation
        dynamic recommendations "update-user-recommendations" "Update user recommendations" {
            cartMicroservice -> recommendationMicroservice "Notifies about added items to cart by user" "Kafka"
            recommendationMicroservice -> cartMicroservice "Request accepted" "Kafka"
            recommendationMicroservice -> recommendationDatabase "Stores user recommendations" "JDBC"
            recommendationDatabase -> recommendationMicroservice "Returns store result" "JDBC"
            autolayout rl
        }

        //Dynamic View: Store user recomendation after reader registration
        dynamic recommendations "store-user-recommendations-after-reader-registration" "Store user recomendation after reader registration" {
            accountMicroservice -> recommendationMicroservice "Stores user recommendations" "Kafka"
            recommendationMicroservice -> accountMicroservice "Recieves user recommendations" "Kafka"
            recommendationMicroservice -> recommendationDatabase "Stores user recommendations" "JDBC"
            recommendationDatabase -> recommendationMicroservice "Returns store result" "JDBC"
            autolayout rl
        }

        // Dynamic View: add item to cart
        dynamic cart "add-item-to-cart" "Add item to cart" {
            reader -> cartSinglePageApplication "Adds item to cart"
            cartSinglePageApplication -> cartMicroservice "Adds item to cart" "HTTPS"
            cartMicroservice -> cartDatabase "Stores item in cart" "JDBC"
            cartDatabase -> cartMicroservice "Returns store result" "JDBC"
            cartMicroservice -> recommendationMicroservice "Notifies about added items to cart" "Kafka"
            recommendationMicroservice -> cartMicroservice "Notified" "Kafka"
            cartMicroservice -> cartSinglePageApplication "Returns store result" "HTTPS"
            cartSinglePageApplication -> reader "Presents cart view"
            autolayout lr
        }

        // Dynamic View: remove item from cart
        dynamic cart "remove-item-from-cart" "Remove item from cart" {
            reader -> cartSinglePageApplication "Removes item from cart"
            cartSinglePageApplication -> cartMicroservice "Removes item from cart" "HTTPS"
            cartMicroservice -> cartDatabase "Removes item from cart" "JDBC"
            cartDatabase -> cartMicroservice "Returns remove result" "JDBC"
            cartMicroservice -> cartSinglePageApplication "Returns remove result" "HTTPS"
            cartSinglePageApplication -> reader "Presents cart view"
            autolayout lr
        }

        // Dynamic View: finalize cart
        dynamic cart "finalize-cart" "Finalize cart" {
            reader -> cartSinglePageApplication "Finalizes cart"
            cartSinglePageApplication -> cartMicroservice "Finalizes cart" "HTTPS"
            cartMicroservice -> cartDatabase "Get cart details" "JDBC"
            cartDatabase -> cartMicroservice "Returns cart details" "JDBC"
            cartMicroservice -> productsMicroservice "Checks cart items availability" "HTTPS"
            productsMicroservice -> productsDatabase "Check products availability" "JDBC"
            productsDatabase -> productsMicroservice "Returns products availability" "JDBC"
            productsMicroservice -> cartMicroservice "Returns cart items availability" "HTTPS"
            cartMicroservice -> financeMicroservice "Request cart payment link" "HTTPS"
            financeMicroservice -> cartMicroservice "Return cart payment link" "HTTPS"
            cartMicroservice -> recommendationMicroservice "Notifies about finalized cart" "Kafka"
            recommendationMicroservice -> cartMicroservice "Acknowledge" "Kafka"
            cartMicroservice -> cartSinglePageApplication "Returns payment link" "HTTPS"
            cartSinglePageApplication -> reader "Presents transaction details"
            autolayout lr
        }

        // Dynamic View: cart paid
        dynamic cart "cart-paid" "Cart paid" {
            financeMicroservice -> cartMicroservice "Notifies about paid cart" "Kafka"
            cartMicroservice -> financeMicroservice "Acknowledge" "Kafka"
            cartMicroservice -> cartDatabase "Marks cart as paid" "JDBC"
            cartDatabase -> cartMicroservice "Returns result" "JDBC"
            cartMicroservice -> shelfMicroservice "Notifies about borrowed items by user" "Kafka"
            shelfMicroservice -> cartMicroservice "Acknowledge" "Kafka"
            autolayout lr
        }

        // Dynamic View: Oversee financial transactions
        dynamic finance "oversee-financial-transactions" "Oversee financial transactions" {
            administrator -> financeSinglePageApplication "Oversees financial transactions"
            financeSinglePageApplication -> financeMicroservice "Requests financial transactions" "HTTPS"
            financeMicroservice -> financeDatabase "Fetches financial transactions" "JDBC"
            financeDatabase -> financeMicroservice "Returns fetched transactions" "JDBC"
            financeMicroservice -> financeSinglePageApplication "Returns fetched transactions" "HTTPS"
            financeSinglePageApplication -> administrator "Presents financial transactions"
            autolayout lr
        }

        // Dynamic View: Generate payment link
        dynamic finance "generate-payment-link" "Generate payment link" {
            cartMicroservice -> financeMicroservice "Generate payment link" "HTTPS"
            financeMicroservice -> financeDatabase "Create payment" "JDBC"
            financeDatabase -> financeMicroservice "Returns payment link" "JDBC"
            financeMicroservice -> cartMicroservice "Return cart payment link" "HTTPS"
            autolayout lr
        }

        // Dynamic View: Send invoice
        dynamic finance "send-invoice" "Send invoice" {
            financeMicroservice -> mail "Sends emails with invoices to readers" "SMTP"
            mail -> reader "Sends invoice"
            reader -> mail "Receives invoice"
            mail -> financeMicroservice "Invoice sent" "SMTP"
            autolayout lr
        }

        // Dynamic View: Make payment
        dynamic finance "make-payment" "Make payment" {
            reader -> financeSinglePageApplication "Makes payment"
            financeSinglePageApplication -> financeMicroservice "Makes payment" "HTTPS"
            financeMicroservice -> financeDatabase "Stores payment" "JDBC"
            financeDatabase -> financeMicroservice "Returns store result" "JDBC"
            financeMicroservice -> cartMicroservice "Cart paid" "Kafka"
            cartMicroservice -> financeMicroservice "Acknowledge" "Kafka"
            financeMicroservice -> financeSinglePageApplication "Returns store result" "HTTPS"
            cartMicroservice -> cartDatabase "Marks cart as paid" "JDBC"
            cartDatabase -> cartMicroservice "Returns result" "JDBC"
            autolayout lr
        }

        styles {
            element "Person" {
                color #ffffff
                background #1565c0
                fontSize 22
                shape Person
            }
            element "Software System" {
                background #2196f3
                color #ffffff
            }
            element "External System" {
                background #9e9e9e
            }
            element "Existing System" {
                background #999999
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            element "Web Browser" {
                shape WebBrowser
            }
            element "Database" {
                shape Cylinder
            }
            element "Component" {
                background #85bbf0
                color #000000
            }
            element "Failover" {
                opacity 25
            }
            relationship "Relationship" {
                color #616161
                style dashed
                routing Orthogonal
            }
        }
    }
}
