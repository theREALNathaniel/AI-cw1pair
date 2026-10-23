(define (problem lunar-mission-1)
    (:domain lunar)

    ; Both images and scans use the data type because they share the same Rover memory 
    (:objects
        rover1 - rover
        lander1 - lander

        wp1 wp2 wp3 wp4 wp5 - waypoint

        image1 scan1 - data

        sample1 - sample
    )

    (:init
        ; Rover initially inside its Lander
        (aboard rover1 lander1)
        (belongs-to rover1 lander1)

        ; Lander landing location
        (lander-at lander1 wp1)

        ; Waypoint connections
        (connected wp1 wp2)
        (connected wp1 wp4)

        (connected wp2 wp3)

        (connected wp3 wp5)

        (connected wp4 wp3)

        (connected wp5 wp1)

        ; Data tasks
        (image-at image1 wp5)
        (scan-at scan1 wp3)

        ; Sample location
        (sample-at sample1 wp1)

        ; Rover memory initially empty
        (memory-free rover1)

        ; Rover can carry one sample
        (sample-capacity-free rover1)

        ; Lander storage initially empty
        (lander-storage-free lander1)
    )

    (:goal
        (and
            ; Image from WP5 transmitted
            (data-transmitted image1 lander1)

            ; Scan from WP3 transmitted
            (data-transmitted scan1 lander1)

            ; Sample from WP1 stored
            (sample-stored sample1 lander1)
        )
    )
)