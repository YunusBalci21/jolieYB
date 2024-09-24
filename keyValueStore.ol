// Interfaces
interface KeyValueStoreInterface {
    RequestResponse:
        put( string key )( any value )( bool result ),
        get( string key )( any response ),
        del( string key )( bool success )
}

// Main service definition
service KeyValueStore {
    inputPort KeyValueInput {
        Location: "socket://localhost:8080"
        Protocol: sodep
        Interfaces: KeyValueStoreInterface
    }

    // Internal in-memory key-value store
    type kvdb: void
    kvdb store

    main {
        [ 
            put( key )( value )( result ) {
                if ( store.(key) == value ) {
                    // No change made to the store
                    println( "Value already exists, no change." )
                    result = false
                } else {
                    // Update the store with the new value
                    store.(key) = value
                    println( "Updated value for key: ", key )
                    result = true
                }
            },

            get( key )( response ) {
                if ( is_defined( store.(key) ) ) {
                    // Return the value for the given key
                    response = store.(key)
                } else {
                    // Key does not exist, return null
                    response = null
                }
            },

            del( key )( success ) {
                if ( is_defined( store.(key) ) ) {
                    undef( store.(key) )
                    println( "Deleted key: ", key )
                    success = true
                } else {
                    success = false
                }
            }
        ]
    }
}
