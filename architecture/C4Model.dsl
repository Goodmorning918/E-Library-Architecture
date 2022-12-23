workspace {

    model {
        reader = person "Reader" "User of E-Library System" "Reader"
        administrator = person "Administrator" "Admin allowed to add position to library" "Library Staff"

        enterprise "E-Library System"  {
            account = softwareSystem "Accounts System" "Allow customer to create, view details and update account."
            shelf = softwareSystem "Shelf" "Store and present user borrowed items"
            products = softwareSystem "Products" "Store and present items in the library"
            cart = softwareSystem "Cart" "Item rental process"{
                cartSinglePageApplication = container "Single Page Application" "Present cart view, allow to use cart functionality from UI" "React Component"
                cartWebApplication = container "Web Application" "Expose API for cart functionality" "Java and Spring Boot"{
                    cartController = component "Cart Controller" "Hande rest request to add items and finalize cart." "Spring MVC Rest Controller"
                    cartManager = component "Cart Manager" "Service orchestrating all functionalities for cart." "Spring Bean"
                    cartRepository = component "Cart Repository" "Performs cart operations on DynamoDb database" "Spring Bean"
                    recommendationConnector = component "Recommendations Connector" "Manages operation for recommendations service" "Spring Bean"
                    productsConnector = component "Products Connector" "Manages operation for products service" "Spring Bean"
                    financesConnector = component "Finances Connector" "Manages operation for finances service" "Spring Bean"
                    cartCalculator = component "Cart Calculator" "Calculate cart cost" "Spring Bean"
                    shelfConnector = component "Shelf Connector" "Manages operation for shelf service" "Spring Bean"
                }
                cartDatabase = container "Database" "Stores user cart" "MongoDb" "Database"
            }
            recommendation = softwareSystem "Recommendations" "Store and expose recommended position for the reader"
            finances = softwareSystem "Finance" "Payment process"
         }

         mail = softwareSystem "Mail Provider" "Send Emails" "External System"

        # relationships between people and software systems
         reader -> account "Creates account" "" relation
         reader -> shelf "Gets borrowed items""" relation
         reader -> products "Gets available items for borrowing" "" relation
         reader -> cart "Adds the item and completes the cart" "" relation
         reader -> recommendation "Gets recommended items" "" relation
         reader -> finances "Makes payment" "" relation
         administrator -> products "Adds product" "" relation
         account -> recommendation "Saves user recommendations""" relation
         finances -> mail "Sends invoice to reader"  "" relation
         cart -> finances "Preparing the payment of the shopping cart" "" relation
         cart -> shelf "Adds borrowed book to user shelf" "" relation
         cart -> recommendation "Adds the item added to the cart to the recommendation" "" relation
         cart -> products "Checks product availability" "" relation

        # relationships to/from containers
         reader -> cartSinglePageApplication "manage cart"
         cartSinglePageApplication -> cartWebApplication "manage cart"  "JSON/HTTPS"
         cartWebApplication -> cartDatabase "Reads from and writes to" "JDBC"

        # relationships to/from components
        cartSinglePageApplication -> cartController "Makes API calls to" "JSON/HTTPS"
        cartController -> cartManager "Uses"
        cartManager -> cartRepository "Uses"
        cartRepository -> cartDatabase "Reads from and writes to" "JDBC"
        cartManager -> recommendationConnector "Uses"
        cartManager -> productsConnector "Uses"
        cartManager -> financesConnector "Uses"
        cartManager -> shelfConnector "Uses"
        recommendationConnector -> recommendation "Makes API calls to" "JSON/HTTPS"
        productsConnector -> products "Makes API calls to" "JSON/HTTPS"
        financesConnector -> finances "Makes API calls to" "JSON/HTTPS"
        shelfConnector -> shelf "Makes API calls to" "JSON/HTTPS"
        cartManager -> cartCalculator "Uses"

    }
    views {
        properties {
            "c4plantuml.elementProperties" "true"
        }
        systemLandscape Library "Big Picture of Library system" {
            autoLayout tb 350
            include *
        }

        systemContext cart "Cart" {
            autoLayout
            include *
        }

        container cart "Cart_Container" {
            include *
            autoLayout
        }

        component cartWebApplication "CartWebApplication_Components" {
            include *
            autoLayout
        }

        styles {
            element "Person" {
                color #ffffff
                fontSize 22
                shape Person
            }
            element "Reader" {
                background #08427b
            }
            element "Library Staff" {
                background #999999
            }
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "External System" {
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
            relationship relation {
                routing Curved
                style solid
            }
        }
    }
}