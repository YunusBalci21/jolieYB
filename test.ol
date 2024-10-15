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
        isValid@date( { date = { year = 2024, month = 10, day = 1 } } )( response )
        println@console( "isValid response (valid date): " + response )()
        isValid@date( { date = { year = 2024, month = 13, day = 35 } } )( response )
        println@console( "isValid response (invalid date): " + response )()

        // Test toString 
        println@console( "--[ Testing toString ]---------------" )()
        toString@date( { date = { year = 2024, month = 10, day = 1 }, format = "YYYY-MM-DD" } )( strResponse )
        println@console( "toString response: " + strResponse )()

        // Test normalise 
        println@console( "--[ Testing normalise ]--------------" )()
        normalise@date( { date = { year = 2023, month = 14, day = 35 } } )( normResponse )
        println@console( "Normalised date:" )()
        println@console( "Year: " + normResponse.date.year )()
        println@console( "Month: " + normResponse.date.month )()
        println@console( "Day: " + normResponse.date.day )()

        // Test add 
        println@console( "--[ Testing add ]---------------------" )()
        add@date( { date = { year = 2023, month = 10, day = 5 }, addYears = 1, addMonths = 2, addDays = 15 } )( addResponse )
        println@console( "Add operation result:" )()
        println@console( "Year: " + addResponse.date.year )()
        println@console( "Month: " + addResponse.date.month )()
        println@console( "Day: " + addResponse.date.day )()

        // Test sub 
        println@console( "--[ Testing sub ]---------------------" )()
        sub@date( { date = { year = 2023, month = 10, day = 5 }, addYears = 1, addMonths = 2, addDays = 15 } )( subResponse )
        if ( is_defined( subResponse.error ) ) {
            println@console( "Sub operation error: " + subResponse.error )()
        } else {
            println@console( "Sub operation result:" )()
            println@console( "Year: " + subResponse.date.year )()
            println@console( "Month: " + subResponse.date.month )()
            println@console( "Day: " + subResponse.date.day )()
        }

        // Test compare 
        println@console( "--[ Testing compare ]-----------------" )()
        compare@date( { date = { year = 2023, month = 10, day = 5 }, addDate = { date = { year = 2023, month = 12, day = 25 } } } )( compResponse )
        if ( compResponse == -1 ) {
            println@console( "Date1 is earlier than Date2" )()
        } else if ( compResponse == 1 ) {
            println@console( "Date1 is later than Date2" )()
        } else if ( compResponse == 0 ) {
            println@console( "Date1 is equal to Date2" )()
        } else {
            println@console( "Unexpected compare response: " + compResponse )()
        }

        // Test earliest 
        println@console( "--[ Testing earliest ]----------------" )()
        earliestRequest.List[0] = { date = { year = 2023, month = 12, day = 25 } }
        earliestRequest.List[1] = { date = { year = 2023, month = 10, day = 5 } }
        earliestRequest.List[2] = { date = { year = 2024, month = 1, day = 1 } }
        earliest@date( earliestRequest )( earliestResponse )
        println@console( "Earliest date is:" )()
        println@console( "Year: " + earliestResponse.date.year )()
        println@console( "Month: " + earliestResponse.date.month )()
        println@console( "Day: " + earliestResponse.date.day )()

        // Test latest 
        println@console( "--[ Testing latest ]------------------" )()
        latestRequest.List[0] = { date = { year = 2023, month = 12, day = 25 } }
        latestRequest.List[1] = { date = { year = 2023, month = 10, day = 5 } }
        latestRequest.List[2] = { date = { year = 2024, month = 1, day = 1 } }
        latest@date( latestRequest )( latestResponse )
        println@console( "Latest date is:" )()
        println@console( "Year: " + latestResponse.date.year )()
        println@console( "Month: " + latestResponse.date.month )()
        println@console( "Day: " + latestResponse.date.day )()
    }
}
