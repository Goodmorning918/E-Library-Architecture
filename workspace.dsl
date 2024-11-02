workspace "E-Library System" "E-Library System" {
    !docs workspace-docs

    model {
        reader = person "Reader" "A user of the E-Library System who interacts with available resources."
        administrator = person "Administrator" "An admin responsible for adding items to the library, managing user accounts, and handling financial transactions."

        accounts = softwareSystem "Accounts" "Enables users to create, view, and update accounts." {
            accountsSpa = container "Accounts SPA" "Provides account management functionality through the user interface." "React Component"
            accountMicroservice = container "Accounts Microservice" "API for account management functionality." "Java and Spring Boot"
            accountDatabase = container "Accounts Database" "Holds user account data." "MongoDB" "Database"
            !docs accounts/docs
        }

        shelf = softwareSystem "Shelf" "Stores and displays items borrowed by users." {
            shelfSpa = container "Shelf SPA" "Interface for managing borrowed items." "React Component"
            shelfMicroservice = container "Shelf Microservice" "API for shelf operations." "Java and Spring Boot"
            shelfDatabase = container "Shelf Database" "Stores borrowed items data." "MongoDB" "Database"
            !docs shelf/docs
        }

        products = softwareSystem "Products" "Maintains and displays items available in the library." {
            productsSpa = container "Products SPA" "Interface for viewing and managing library items." "React Component"
            productsMicroservice = container "Products Microservice" "API for managing library items." "Java and Spring Boot"
            productsDatabase = container "Products Database" "Stores library items." "MongoDB" "Database"
            !docs products/docs
        }

        cart = softwareSystem "Cart" "Handles the item rental process." {
            cartSpa = container "Cart SPA" "Interface for managing cart items." "React Component"
            cartMicroservice = container "Cart Microservice" "API for cart operations." "Java and Spring Boot"
            cartDatabase = container "Cart Database" "Stores items currently in the cart." "MongoDB" "Database"
            !docs cart/docs
        }

        recommendations = softwareSystem "Recommendations" "Provides recommended items for users." {
            recommendationsSpa = container "Recommendations SPA" "Interface for viewing recommendations." "React Component"
            recommendationMicroservice = container "Recommendations Microservice" "API for recommendation functionality." "Java and Spring Boot"
            recommendationDatabase = container "Recommendations Database" "Stores recommended items." "MongoDB" "Database"
            !docs recommendations/docs
        }

        finance = softwareSystem "Finance" "Manages financial transactions and payment processing." {
            financeSpa = container "Finance SPA" "Interface for financial management." "React Component"
            financeMicroservice = container "Finance Microservice" "API for finance operations." "Java and Spring Boot"
            financeDatabase = container "Finance Database" "Holds financial transaction data." "PostgreSQL" "Database"
            !docs finance/docs
        }

        mail = softwareSystem "Mail Provider" "External system for sending emails." "External System" {
            !docs mail-provider/docs
        }

        // Define system relationships
        reader -> accounts "Manages their account."
        reader -> shelf "Manages borrowed items."
        reader -> products "Views available items."
        reader -> cart "Handles rental process."
        reader -> recommendations "Views recommended items."
        reader -> finance "Manages payments."

        cart -> finance "Processes payments."

        administrator -> accounts "Oversees user accounts."
        administrator -> products "Manages library items."
        administrator -> finance "Oversees financial transactions."

        mail -> reader "Sends invoices."

        // Define container relationships
        reader -> accountsSpa "Accesses account functionality."
        reader -> shelfSpa "Views and manages borrowed items."
        reader -> productsSpa "Views available library items."
        reader -> cartSpa "Manages cart."
        reader -> recommendationsSpa "Views recommendations."
        reader -> financeSpa "Makes payments."

        administrator -> productsSpa "Manages library items."
        administrator -> financeSpa "Oversees financial transactions."
        administrator -> accountsSpa "Manages accounts."

        accountsSpa -> accountMicroservice "Requests account operations." "HTTPS"
        accountMicroservice -> accountDatabase "Stores and retrieves accounts." "JDBC"
        accountMicroservice -> recommendationMicroservice "Updates recommendations." "Kafka"

        shelfSpa -> shelfMicroservice "Requests shelf operations." "HTTPS"
        shelfMicroservice -> shelfDatabase "Stores and retrieves borrowed items." "JDBC"

        productsSpa -> productsMicroservice "Requests product operations." "HTTPS"
        productsMicroservice -> productsDatabase "Stores and retrieves library items." "JDBC"

        cartSpa -> cartMicroservice "Requests cart operations." "HTTPS"
        cartMicroservice -> cartDatabase "Stores cart items." "JDBC"
        cartMicroservice -> recommendationMicroservice "Updates recommendations." "Kafka"
        cartMicroservice -> shelfMicroservice "Notifies borrowed items." "Kafka"
        cartMicroservice -> productsMicroservice "Checks item availability." "HTTPS"
        cartMicroservice -> financeMicroservice "Generates payment link." "HTTPS"
        cartMicroservice -> financeMicroservice "Processes payment notifications." "Kafka"

        recommendationsSpa -> recommendationMicroservice "Requests recommendations." "HTTPS"
        recommendationMicroservice -> recommendationDatabase "Stores and retrieves recommendations." "JDBC"

        financeSpa -> financeMicroservice "Requests financial operations." "HTTPS"
        financeMicroservice -> financeDatabase "Stores and retrieves transactions." "JDBC"
        financeMicroservice -> mail "Sends invoices to readers." "SMTP"
    }
    views {
        properties {
            "generatr.style.colors.primary" "#009688"
            "generatr.style.colors.secondary" "#ffffff"
            "generatr.style.faviconPath" "site/logo.png"
            "generatr.style.logoPath" "site/logo.png"
            "generatr.style.customStylesheet" "site/custom.css"
            "generatr.svglink.target" "_self"
            "generatr.markdown.flexmark.extensions" "Abbreviation,Admonition,AnchorLink,Attributes,Autolink,Definition,Emoji,Footnotes,GfmTaskList,GitLab,MediaTags,Tables,TableOfContents,Typographic"
            "c4plantuml.elementProperties" "true"
            "c4plantuml.tags" "true"
            "plantuml.sequenceDiagram" "true"
            "plantuml.animation" "true"
            "plantuml.shadow" "true"
            "generatr.site.exporter" "structurizr"
            "generatr.site.nestGroups" "true"
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
        dynamic accounts "reader-registration" "Reader Registration Process" {
            reader -> accountsSpa "Initiates account registration"
            accountsSpa -> accountMicroservice "Requests new account creation" "HTTPS"
            accountMicroservice -> accountDatabase "Stores new account data" "JDBC"
            accountDatabase -> accountMicroservice "Confirms account creation" "JDBC"
            accountMicroservice -> recommendationMicroservice "Updates recommendations for new user" "Kafka"
            recommendationMicroservice -> accountMicroservice "Acknowledges recommendation update" "Kafka"
            accountMicroservice -> accountsSpa "Sends account details" "HTTPS"
            accountsSpa -> reader "Displays created account details"
            autolayout lr
        }

        // Dynamic View: Add Books to Shelf
        dynamic shelf "add-books-to-shelf" "Process of Adding Books to Shelf" {
            cartMicroservice -> shelfMicroservice "Notifies borrowed items" "Kafka"
            shelfMicroservice -> cartMicroservice "Acknowledges receipt of items" "Kafka"
            shelfMicroservice -> shelfDatabase "Stores borrowed items" "JDBC"
            shelfDatabase -> shelfMicroservice "Confirms storage" "JDBC"
            autolayout rl
        }

        // Dynamic View: Present Books from Reader Shelf
        dynamic shelf "present-books-from-reader-shelf" "View Reader's Borrowed Books" {
            reader -> shelfSpa "Requests borrowed items view"
            shelfSpa -> shelfMicroservice "Fetches borrowed items" "HTTPS"
            shelfMicroservice -> shelfDatabase "Retrieves borrowed items data" "JDBC"
            shelfDatabase -> shelfMicroservice "Returns borrowed items data" "JDBC"
            shelfMicroservice -> shelfSpa "Returns borrowed items to UI" "HTTPS"
            shelfSpa -> reader "Displays borrowed items view"
            autolayout rl
        }

        // Dynamic View: Add Book to Library
        dynamic products "add-book-to-library" "Adding a New Book to the Library" {
            administrator -> productsSpa "Initiates new book addition"
            productsSpa -> productsMicroservice "Processes new book addition" "HTTPS"
            productsMicroservice -> productsDatabase "Stores book data" "JDBC"
            productsDatabase -> productsMicroservice "Confirms book storage" "JDBC"
            productsMicroservice -> productsSpa "Returns new book ID" "HTTPS"
            productsSpa -> administrator "Displays new book details"
            autolayout lr
        }

        // Dynamic View: Remove Book from Library
        dynamic products "remove-book-from-library" "Removing a Book from the Library" {
            administrator -> productsSpa "Initiates book removal"
            productsSpa -> productsMicroservice "Processes book removal" "HTTPS"
            productsMicroservice -> productsDatabase "Removes book data" "JDBC"
            productsDatabase -> productsMicroservice "Confirms book removal" "JDBC"
            productsMicroservice -> productsSpa "Returns removal status" "HTTPS"
            productsSpa -> administrator "Displays removal details"
            autolayout lr
        }

        // Dynamic View: Present Available Books
        dynamic products "present-available-books" "Viewing Available Books in Library" {
            reader -> productsSpa "Requests available books list"
            productsSpa -> productsMicroservice "Fetches available books" "HTTPS"
            productsMicroservice -> productsDatabase "Retrieves available books" "JDBC"
            productsDatabase -> productsMicroservice "Returns available books" "JDBC"
            productsMicroservice -> productsSpa "Returns book data" "HTTPS"
            productsSpa -> reader "Displays available books list"
            autolayout lr
        }

        // Dynamic View: Present Recommended Products
        dynamic recommendations "present-recommended-products" "Viewing Recommended Books for User" {
            reader -> recommendationsSpa "Requests recommendations"
            recommendationsSpa -> recommendationMicroservice "Fetches recommendations" "HTTPS"
            recommendationMicroservice -> recommendationDatabase "Retrieves recommended items" "JDBC"
            recommendationDatabase -> recommendationMicroservice "Returns recommendations" "JDBC"
            recommendationMicroservice -> recommendationsSpa "Returns recommended items" "HTTPS"
            recommendationsSpa -> reader "Displays recommended items"
            autolayout lr
        }

        // Dynamic View: Update User Recommendations
        dynamic recommendations "update-user-recommendations" "Updating User Recommendations" {
            cartMicroservice -> recommendationMicroservice "Notifies added items to cart" "Kafka"
            recommendationMicroservice -> cartMicroservice "Acknowledges notification" "Kafka"
            recommendationMicroservice -> recommendationDatabase "Stores updated recommendations" "JDBC"
            recommendationDatabase -> recommendationMicroservice "Confirms storage" "JDBC"
            autolayout rl
        }

        // Dynamic View: Store User Recommendations after Registration
        dynamic recommendations "store-user-recommendations-after-reader-registration" "Initial User Recommendations Setup" {
            accountMicroservice -> recommendationMicroservice "Sends user recommendations data" "Kafka"
            recommendationMicroservice -> accountMicroservice "Acknowledges data receipt" "Kafka"
            recommendationMicroservice -> recommendationDatabase "Stores recommendations" "JDBC"
            recommendationDatabase -> recommendationMicroservice "Confirms storage" "JDBC"
            autolayout rl
        }

        // Dynamic View: Add Item to Cart
        dynamic cart "add-item-to-cart" "Adding Item to Cart" {
            reader -> cartSpa "Adds item to cart"
            cartSpa -> cartMicroservice "Processes cart addition" "HTTPS"
            cartMicroservice -> cartDatabase "Stores cart item" "JDBC"
            cartDatabase -> cartMicroservice "Confirms storage" "JDBC"
            cartMicroservice -> recommendationMicroservice "Updates recommendations based on cart activity" "Kafka"
            recommendationMicroservice -> cartMicroservice "Acknowledges update" "Kafka"
            cartMicroservice -> cartSpa "Confirms cart addition" "HTTPS"
            cartSpa -> reader "Displays cart"
            autolayout lr
        }

        // Dynamic View: Remove Item from Cart
        dynamic cart "remove-item-from-cart" "Removing Item from Cart" {
            reader -> cartSpa "Removes item from cart"
            cartSpa -> cartMicroservice "Processes cart removal" "HTTPS"
            cartMicroservice -> cartDatabase "Removes cart item" "JDBC"
            cartDatabase -> cartMicroservice "Confirms removal" "JDBC"
            cartMicroservice -> cartSpa "Confirms cart removal" "HTTPS"
            cartSpa -> reader "Updates cart view"
            autolayout lr
        }

        // Dynamic View: Finalize Cart
        dynamic cart "finalize-cart" "Completing the Cart Process" {
            reader -> cartSpa "Finalizes cart"
            cartSpa -> cartMicroservice "Processes cart finalization" "HTTPS"
            cartMicroservice -> cartDatabase "Retrieves cart details" "JDBC"
            cartDatabase -> cartMicroservice "Returns cart details" "JDBC"
            cartMicroservice -> productsMicroservice "Checks item availability" "HTTPS"
            productsMicroservice -> productsDatabase "Verifies product availability" "JDBC"
            productsDatabase -> productsMicroservice "Returns availability status" "JDBC"
            productsMicroservice -> cartMicroservice "Provides availability details" "HTTPS"
            cartMicroservice -> financeMicroservice "Generates payment link" "HTTPS"
            financeMicroservice -> cartMicroservice "Returns payment link" "HTTPS"
            cartMicroservice -> recommendationMicroservice "Finalizes recommendations" "Kafka"
            recommendationMicroservice -> cartMicroservice "Acknowledges finalization" "Kafka"
            cartMicroservice -> cartSpa "Presents payment link" "HTTPS"
            cartSpa -> reader "Displays transaction details"
            autolayout lr
        }

        // Dynamic View: Cart Paid
        dynamic cart "cart-paid" "Updating Cart Status to Paid" {
            financeMicroservice -> cartMicroservice "Notifies of completed payment" "Kafka"
            cartMicroservice -> financeMicroservice "Acknowledges payment" "Kafka"
            cartMicroservice -> cartDatabase "Marks cart as paid" "JDBC"
            cartDatabase -> cartMicroservice "Confirms payment status" "JDBC"
            cartMicroservice -> shelfMicroservice "Updates borrowed items" "Kafka"
            shelfMicroservice -> cartMicroservice "Acknowledges update" "Kafka"
            autolayout lr
        }

        // Dynamic View: Oversee Financial Transactions
        dynamic finance "oversee-financial-transactions" "Administrative Review of Financial Transactions" {
            administrator -> financeSpa "Reviews financial transactions"
            financeSpa -> financeMicroservice "Requests transaction data" "HTTPS"
            financeMicroservice -> financeDatabase "Retrieves transactions" "JDBC"
            financeDatabase -> financeMicroservice "Returns transaction data" "JDBC"
            financeMicroservice -> financeSpa "Provides transaction data" "HTTPS"
            financeSpa -> administrator "Displays transaction overview"
            autolayout lr
        }

        // Dynamic View: Generate Payment Link
        dynamic finance "generate-payment-link" "Creating a Payment Link" {
            cartMicroservice -> financeMicroservice "Requests payment link" "HTTPS"
            financeMicroservice -> financeDatabase "Creates payment entry" "JDBC"
            financeDatabase -> financeMicroservice "Confirms payment link" "JDBC"
            financeMicroservice -> cartMicroservice "Returns payment link" "HTTPS"
            autolayout lr
        }

        // Dynamic View: Send Invoice
        dynamic finance "send-invoice" "Invoice Email Process" {
            financeMicroservice -> mail "Sends invoice to reader" "SMTP"
            mail -> reader "Receives invoice"
            reader -> mail "Confirms invoice receipt"
            mail -> financeMicroservice "Confirms email sent" "SMTP"
            autolayout lr
        }

        // Dynamic View: Make Payment
        dynamic finance "make-payment" "Processing Payment for Cart Items" {
            reader -> financeSpa "Initiates payment"
            financeSpa -> financeMicroservice "Processes payment request" "HTTPS"
            financeMicroservice -> financeDatabase "Stores payment details" "JDBC"
            financeDatabase -> financeMicroservice "Confirms payment storage" "JDBC"
            financeMicroservice -> cartMicroservice "Notifies cart as paid" "Kafka"
            cartMicroservice -> financeMicroservice "Acknowledges payment notification" "Kafka"
            financeMicroservice -> financeSpa "Returns payment status" "HTTPS"
            cartMicroservice -> cartDatabase "Updates cart to paid status" "JDBC"
            cartDatabase -> cartMicroservice "Confirms update" "JDBC"
            financeSpa -> reader "Displays payment confirmation"
            autolayout lr
        }

        styles {
            element "Person" {
                color #ffffff
                background #00796B
                fontSize 22
                shape Person
            }
            element "Software System" {
                background #009688
                color #ffffff
            }
            element "External System" {
                background #4DB6AC
                color #ffffff
            }
            element "Existing System" {
                background #004D40
                color #ffffff
            }
            element "Container" {
                background #26A69A
                color #ffffff
            }
            element "Web Browser" {
                shape WebBrowser
            }
            element "Database" {
                shape Cylinder
            }
            element "Component" {
                background #80CBC4
                color #000000
            }
            element "Failover" {
                opacity 25
            }
            relationship "Relationship" {
                color #004D40
                style dashed
                routing Orthogonal
            }
        }
    }
}
