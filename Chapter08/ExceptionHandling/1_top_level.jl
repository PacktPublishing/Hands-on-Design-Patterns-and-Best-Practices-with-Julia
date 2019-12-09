try
    # 1. do some work related to reading writing files
    # 2. invoke an HTTP request to a remote web service
    # 3. create a status report in PDF and save in a network drive
catch ex
    if ex isa FileNotFoundError
        println("Having trouble with reading local file")
        exit(1)
    elseif ex isa HTTPRequestError
        println("Unable to communicate with web service")
        exit(2)
    elseif ex isa NetworkDriveNotReadyError
        println("All done, except that the report cannot be saved")
        exit(3)
    else
        println("An unknown error has occured, please report. Error=", ex)
        exit(255)
    end
end