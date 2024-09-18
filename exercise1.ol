from console import Console
from string_utils import StringUtils
from date_utils import DateUtils, DateParseException

service Main {
  embed Console as console
  embed StringUtils as stringUtils
  embed DateUtils as dateUtils

  main {
    // input date
    dateString = "2024-09-13"

    // validate the date
    result = false;

    try {
      parsedDate = parseDate@dateUtils(dateString, "yyyy-MM-dd")
      result = true;
    } catch (DateParseException e) {
      result = false;
    }

    // now convert the result to a pretty string format
    valueToPrettyString@stringUtils(result)(prettyResult)

    if (result) {
      println@console("The date " + dateString + " is valid. Result: " + prettyResult)()
    } else {
      println@console("The date " + dateString + " is invalid. Result: " + prettyResult)()
    }
  }
}
