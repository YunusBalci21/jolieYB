type Date: void {
    year: int
    month: int
    day: int
}

type DateFormat: string( enum(["YYYY-MM-DD", "MM-DD-YYYY", "DD-MM-YYYY"]) )

type isValid: void {
    date: Date
}

type toString: void {
    date: Date
    format: DateFormat
}

type normalise: void {
    date: Date
}

type DateMath: void {
    date: Date
    addYears?: int
    addMonths?: int
    addDays?: int
    addDate?: Date
}


type DateinArray: void {
    List[0,*]: Date
}


interface dateInterface {
    RequestResponse:
        isValid( Date ) ( bool ),
        toString( Date ) ( string ),
        normalise( Date ) ( Date ),
        add( DateMath ) ( Date ),
        sub( DateMath ) ( Date ),
        compare( DateMath ) ( int ),
        earliest( DateinArray ) ( Date ),
        latest( DateinArray ) ( Date )
}

service Dates {
    execution: sequential

    inputPort localIP {
        location: "local"
        interfaces: dateInterface
    }

    main {
        [ isValid( request )( response ) {
            year = request.date.year
            month = request.date.month
            day = request.date.day

            if ( year <= 0 || month < 1 || month > 12 || day < 1 ) {
                response = false
            } else {
                leapyear = ( year % 4 == 0 && year % 100 != 0 ) || ( year % 400 == 0 )
                maxDays = 31
                if ( month == 2 ) {
                    if ( leapyear ) {
                        maxDays = 29
                    } else {
                        maxDays = 28
                    }
                } else if ( month == 4 || month == 6 || month == 9 || month == 11 ) {
                    maxDays = 30
                }
                response = day <= maxDays
            }
        }]

        [ toString( request )( response ) {
            year = request.date.year
            month = request.date.month
            day = request.date.day
            format = request.format

            monthStr = ""
            if ( month < 10 ) {
                monthStr = "0" + month
            } else {
                monthStr = "" + month
            }

            dayStr = ""
            if ( day < 10 ) {
                dayStr = "0" + day
            } else {
                dayStr = "" + day
            }

            if ( format == "YYYY-MM-DD" ) {
                response = year + "-" + monthStr + "-" + dayStr
            } else if ( format == "MM-DD-YYYY" ) {
                response = monthStr + "-" + dayStr + "-" + year
            } else if ( format == "DD-MM-YYYY" ) {
                response = dayStr + "-" + monthStr + "-" + year
            } else {
                response = year + "-" + monthStr + "-" + dayStr
            }
        }]

        [ normalise( request )( response ) {
            year = request.date.year
            month = request.date.month
            day = request.date.day

            dayNormalised = false
            while ( day > 28 && !dayNormalised ) {
                maxDays = 31
                if ( month == 2 ) {
                    leapyear = ( year % 4 == 0 && year % 100 != 0 ) || ( year % 400 == 0 )
                    if ( leapyear ) {
                        maxDays = 29
                    } else {
                        maxDays = 28
                    }
                } else if ( month == 4 || month == 6 || month == 9 || month == 11 ) {
                    maxDays = 30
                }
                if ( day > maxDays ) {
                    day = day - maxDays
                    month = month + 1
                } else {
                    dayNormalised = true
                }
            }

            monthNormalised = false
            while ( month > 12 && !monthNormalised ) {
                month = month - 12
                year = year + 1
                monthNormalised = true
            }

            response.date.year = year
            response.date.month = month
            response.date.day = day
        }]

        [ add( request )( response ) {
            year = request.date.year
            month = request.date.month
            day = request.date.day

            totalYears = year
            totalMonths = month
            totalDays = day

            if ( is_defined( request.addYears ) ) {
                totalYears = totalYears + request.addYears
            }

            if ( is_defined( request.addMonths ) ) {
                totalMonths = totalMonths + request.addMonths
            }

            if ( is_defined( request.addDays ) ) {
                totalDays = totalDays + request.addDays
            }

            if ( is_defined( request.addDate ) ) {
                totalYears = totalYears + request.addDate.year
                totalMonths = totalMonths + request.addDate.month
                totalDays = totalDays + request.addDate.day
            }

            while ( totalMonths > 12 ) {
                totalMonths = totalMonths - 12
                totalYears = totalYears + 1
            }

            dayNormalised = false
            while ( !dayNormalised ) {
                maxDays = 31
                if ( totalMonths == 2 ) {
                    leapyear = ( totalYears % 4 == 0 && ( totalYears % 100 != 0 || totalYears % 400 == 0 ) )
                    if ( leapyear ) {
                        maxDays = 29
                    } else {
                        maxDays = 28
                    }
                } else if ( totalMonths == 4 || totalMonths == 6 || totalMonths == 9 || totalMonths == 11 ) {
                    maxDays = 30
                }
                if ( totalDays > maxDays ) {
                    totalDays = totalDays - maxDays
                    totalMonths = totalMonths + 1
                    if ( totalMonths > 12 ) {
                        totalMonths = totalMonths - 12
                        totalYears = totalYears + 1
                    }
                } else {
                    dayNormalised = true
                }
            }

            response.year = totalYears
            response.month = totalMonths
            response.day = totalDays
        }]

        [ sub( request )( response ) {
            year = request.date.year
            month = request.date.month
            day = request.date.day

            totalYears = year
            totalMonths = month
            totalDays = day

            if ( is_defined( request.addYears ) ) {
                totalYears = totalYears - request.addYears
            }

            if ( is_defined( request.addMonths ) ) {
                totalMonths = totalMonths - request.addMonths
            }

            if ( is_defined( request.addDays ) ) {
                totalDays = totalDays - request.addDays
            }

            if ( is_defined( request.addDate ) ) {
                totalYears = totalYears - request.addDate.year
                totalMonths = totalMonths - request.addDate.month
                totalDays = totalDays - request.addDate.day
            }

            while ( totalMonths < 1 ) {
                totalMonths = totalMonths + 12
                totalYears = totalYears - 1
            }

            dayNormalised = false
            while ( !dayNormalised ) {
                if ( totalDays < 1 ) {
                    totalMonths = totalMonths - 1
                    if ( totalMonths < 1 ) {
                        totalMonths = totalMonths + 12
                        totalYears = totalYears - 1
                    }

                    maxDays = 31
                    if ( totalMonths == 2 ) {
                        leapyear = ( totalYears % 4 == 0 && ( totalYears % 100 != 0 || totalYears % 400 == 0 ) )
                        if ( leapyear ) {
                            maxDays = 29
                        } else {
                            maxDays = 28
                        }
                    } else if ( totalMonths == 4 || totalMonths == 6 || totalMonths == 9 || totalMonths == 11 ) {
                        maxDays = 30
                    }

                    totalDays = totalDays + maxDays
                } else {
                    dayNormalised = true
                }
            }

            if ( totalYears <= 0 ) {
                response.error = "InvalidDate"
            } else {
                response.date.year = totalYears
                response.date.month = totalMonths
                response.date.day = totalDays
            }
        }]

        [ compare( request )( response ) {
            if ( !is_defined( request.addDate ) ) {
                response = -2
            } else {
                date1 = request.date
                date2 = request.addDate

                date1Value = date1.year * 10000 + date1.month * 100 + date1.day
                date2Value = date2.year * 10000 + date2.month * 100 + date2.day

                if ( date1Value < date2Value ) {
                    response = -1
                } else if ( date1Value > date2Value ) {
                    response = 1
                } else {
                    response = 0
                }
            }
        }]

        [ earliest( request )( response ) {
            if ( #request.List == 0 ) {
                throw( NoDatesProvided )
            } else {
                earliestDate = request.List[0]
                earliestValue = earliestDate.year * 10000 + earliestDate.month * 100 + earliestDate.day

                for( i = 1, i < #request.List, i = i + 1 ) {
                    currentDate = request.List[i]
                    currentValue = currentDate.year * 10000 + currentDate.month * 100 + currentDate.day

                    if ( currentValue < earliestValue ) {
                        earliestDate = currentDate
                        earliestValue = currentValue
                    }
                }

                response = earliestDate
            }
        }]

        [ latest ( request )( response ) {
            if ( #request.List == 0 ) {
                throw( NoDatesProvided )
            } else {
                latestDate = request.List[0]
                latestValue = latestDate.year * 10000 + latestDate.month * 100 + latestDate.day

                for ( i = 1, i < #request.List, i = i + 1 ) {
                    currentDate = request.List[i]
                    currentValue = currentDate.year * 10000 + currentDate.month * 100 + currentDate.day

                    if ( currentValue > latestValue ) {
                        latestDate = currentDate
                        latestValue = currentValue
                    }
                }
            }

            response = latestDate
        }]
    }
}
