from .date2 import Date, DateFormat, isValid, toString, normalise, DateMath, DateinArray, dateInterface
from console import Console

service main {
    execution: single

    outputPort date {
        location: "local"
        protocol: local
        interfaces: dateInterface
    }

    embed Console as console

    main {
        // Test isValid 
        println@console( "--[ Testing isValid ]----------------" )()
        isValid@date( date = { year = 2024, month = 10, day = 1 } )( response )
        println@console( "isValid response (valid date): " + response )()
        isValid@date( { date = { year = 2024, month = 13, day = 35 } } )( response )
        println@console( "isValid response (invalid date): " + response )()

        // Test toString 
        println@console( "--[ Testing toString ]---------------" )()
        toString@date( 
            { date = { year = 2024, month = 10, day = 1 }, format = "YYYY-MM-DD" }
        )( strResponse )
        println@console( "toString response: " + strResponse )()

        // Test normalise 
        println@console( "--[ Testing normalise ]--------------" )()
        normalise@date( date = { year = 2023, month = 14, day = 35 } )( normResponse )
        println@console( "Normalised date:" )()
        println@console( "Year: " + normResponse.year )()
        println@console( "Month: " + normResponse.month )()
        println@console( "Day: " + normResponse.day )()

        // Test add 
        println@console( "--[ Testing add ]---------------------" )()
        add@date( 
            { date = { year = 2023, month = 10, day = 5 }, addYears = 1, addMonths = 2, addDays = 15 }
        )( addResponse )        
        println@console( "Add operation result:" )()
        println@console( "Year: " + addResponse.year )()
        println@console( "Month: " + addResponse.month )()
        println@console( "Day: " + addResponse.day )()

        // Test sub 
        println@console( "--[ Testing sub ]---------------------" )()
        sub@date( 
            { date = { year = 2023, month = 10, day = 5 }, subYears = 1, subMonths = 2, subDays = 15 }
        )( subResponse )
        if ( is_defined( subResponse.error ) ) {
            println@console( "Sub operation error: " + subResponse.error )()
        } else {
            println@console( "Sub operation result:" )()
            println@console( "Year: " + subResponse.year )()
            println@console( "Month: " + subResponse.month )()
            println@console( "Day: " + subResponse.day )()
        }

        // Test compare 
        println@console( "--[ Testing compare ]-----------------" )()
        compare@date( 
            { date1 = { year = 2023, month = 10, day = 5 }, date2 = { year = 2023, month = 12, day = 25 } }
        )( compResponse )
        if ( compResponse == -1 ) {
            println@console( "Date1 is earlier than Date2" )()
        } else if ( compResponse == 1 ) {
            println@console( "Date1 is later than Date2" )()
        } else if ( compResponse == 0 ) {
            println@console( "Date1 is equal to Date2" )()
        } else {
            println@console( "Unexpected compare response: " + compResponse )()
        }

        // Declare the earliestRequest array outside the main block
        earliestRequest = [
            { year = 2023, month = 12, day = 25 }
            { year = 2023, month = 10, day = 5 }
            { year = 2024, month = 1, day = 1 }
            ]

        // Test earliest 
        println@console( "--[ Testing earliest ]----------------" )()
        earliest@date( date = earliestRequest )( earliestResponse )
        println@console( "Earliest date is:" )()
        println@console( "Year: " + earliestResponse.year )()
        println@console( "Month: " + earliestResponse.month )()
        println@console( "Day: " + earliestResponse.day )()

        // Declare the latestRequest array outside the main block
        latestRequest = [
            { year = 2023, month = 12, day = 25 },
            { year = 2023, month = 10, day = 5 },
            { year = 2024, month = 1, day = 1 }
        ]

        // Test latest 
        println@console( "--[ Testing latest ]------------------" )()
        latest@date( date = latestRequest )( latestResponse )
        println@console( "Latest date is:" )()
        println@console( "Year: " + latestResponse.year )()
        println@console( "Month: " + latestResponse.month )()
        println@console( "Day: " + latestResponse.day )()
    }
}
