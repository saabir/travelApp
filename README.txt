README FOR TRAVELAPP PROTOTYPE
------------------------------

IMPORTANT:
Currently travelApp has to initialize the Core Data database when it is
started for the first time. Due to the amount of data this can take up to
30 minutes.

Please do not close or stop the program during this phase. Database initialisation is finished as soon as the following line is given in the log:

 Weather created : 2519

Please restart the App after successfull database initialisation.

Database initialisation is only needed, if the app is run for the first time
or if the app is deleted from the simulator/device and re-run again.


THE FOLLOWING OPTIONS ARE CURRENTLY PROVIDED:
- find current location
- show help movie (although the movie is slightly outdated)
- zoom/move interactive map

- select country from list sorted by continents
- search country by weather criteria
- show country information when clicking on marker on country
  (country must be selected from the list first)