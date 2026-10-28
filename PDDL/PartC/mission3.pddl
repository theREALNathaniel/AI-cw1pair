(define (problem lunar-mission-3)
    (:domain lunar-extended)

    (:objects
        rover1 rover2 - rover

        lander1 lander2 - lander

        wp1 wp2 wp3 wp4 wp5 wp6 - waypoint

        ; Both images and scans use the data type because they share the same Rover memory 
        image1 image2 scan1 scan2 - data 

        sample1 sample2 - sample

        astronaut1 astronaut2 - astronaut
    )

    (:init
        ; Rover1 is already depolyed at wp2 and belongs to lander1
        (at rover1 wp2)
        (deployed rover1)
        (belongs-to rover1 lander1)
        (lander-at lander1 wp2)

        ; Rover2 initially inside its Lander2
        (aboard rover2 lander2)
        (belongs-to rover2 lander2)

        ; Lander2 landing location
        (lander-at lander2 wp1)


        ; Alice belongs to Lander1
        (astronaut-belongs-to astronaut1 lander1)

        ; Bob belongs to Lander2
        (astronaut-belongs-to astronaut2 lander2)

        ; Alice initially in docking bay
        (in-docking-bay astronaut1 lander1)

        ; Bob initially in control room
        (in-control-room astronaut2 lander2)


        ; Waypoint connections
        (connected wp1 wp2)

        (connected wp2 wp1)
        (connected wp2 wp3)
        (connected wp2 wp4)

        (connected wp3 wp5)

        (connected wp4 wp2)

        (connected wp5 wp3)
        (connected wp5 wp6)

        (connected wp6 wp4)


        ; Data tasks
        (image-at image1 wp3)
        (scan-at scan1 wp4)
        (image-at image2 wp2)
        (scan-at scan2 wp6)

        ; Sample location
        (sample-at sample1 wp5)
        (sample-at sample2 wp1)

        ; Rovers memory initially empty
        (memory-free rover1)
        (memory-free rover2)

        ; Rovers can carry one sample
        (sample-capacity-free rover1)
        (sample-capacity-free rover2)

        ; Landers storage initially empty
        (lander-storage-free lander1)
        (lander-storage-free lander2)
    )

    (:goal
        (and
            ; Image from WP3 transmitted to lander1
            (data-transmitted image1 lander1)

            ; Scan from WP4 transmitted to lander2
            (data-transmitted scan1 lander2)

            ; Image from WP2 transmitted to lander2
            (data-transmitted image2 lander2)

            ; Scan from WP6 transmitted to lander1
            (data-transmitted scan2 lander1)

            ; Sample from WP5 stored in lander1
            (sample-stored sample1 lander1)

            ; Sample from WP1 stored in lander 2
            (sample-stored sample2 lander2)
        )
    )
)