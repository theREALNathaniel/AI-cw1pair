(define (domain lunar-extended)
    (:requirements :strips :typing)

    (:types
        rover
        lander
        waypoint
        data
        sample
        astronaut
    )

    (:predicates
        ; Rover and Lander locations
        (at ?r - rover ?w - waypoint)
        (lander-at ?l - lander ?w - waypoint)

        ; Rover belongs to a particular Lander
        (belongs-to ?r - rover ?l - lander)

        ; Rover deployment
        (aboard ?r - rover ?l - lander)
        (deployed ?r - rover)
        
        ; Waypoint connectivity
        (connected ?from - waypoint ?to - waypoint)

        ; Data locations and types
        (image-at ?d - data ?w - waypoint)
        (scan-at ?d - data ?w - waypoint)

        ; Rover memory
        ; If Rover is free = memory-free. If carrying data/not free = carrying-data
        (memory-free ?r - rover)
        (carrying-data ?r - rover ?d - data)

        ; Successfully transmitted data
        (data-transmitted ?d - data ?l - lander)

        ; Samples
        (sample-at ?s - sample ?w - waypoint)
        (carrying-sample ?r - rover ?s - sample)
        (sample-capacity-free ?r - rover)

        ; Lander sample storage
        (lander-storage-free ?l - lander)
        (sample-stored ?s - sample ?l - lander)

        ; Astronaut belong to which lander
        (astronaut-belongs-to ?a - astronaut ?l - lander)

        ; Astronaut is in the docking bay
        (in-docking-bay ?a - astronaut ?l - lander)

        ; Astronaut is in the control room
        (in-control-room ?a - astronaut ?l - lander)
    )

    (:action deploy
        :parameters 
        (
            ?r - rover
            ?l - lander
            ?w - waypoint
            ?a - astronaut
        )

        :precondition 
        (and
            (aboard ?r ?l)
            (belongs-to ?r ?l)
            (lander-at ?l ?w)

            ; Astronaut must be in the docking bay
            (astronaut-belongs-to ?a ?l)
            (in-docking-bay ?a ?l)
        )

        :effect 
        (and
            (deployed ?r)
            (at ?r ?w)
            (not (aboard ?r ?l))
        )
    )

    (:action move
        :parameters 
        (
            ?r - rover
            ?from - waypoint
            ?to - waypoint
        )

        :precondition 
        (and
            (deployed ?r)
            (at ?r ?from)
            (connected ?from ?to)
        )

        :effect 
        (and
            (not (at ?r ?from))
            (at ?r ?to)
        )
    )

    (:action capture-image
        :parameters 
        (
            ?r - rover
            ?d - data
            ?w - waypoint
        )

        :precondition 
        (and
            (deployed ?r)
            (at ?r ?w)
            (image-at ?d ?w)
            (memory-free ?r)
        )

        :effect 
        (and
            (carrying-data ?r ?d)
            (not (memory-free ?r))
            (not (image-at ?d ?w))
        )
    )

    (:action perform-scan
        :parameters 
        (
            ?r - rover
            ?d - data
            ?w - waypoint
        )

        :precondition 
        (and
            (deployed ?r)
            (at ?r ?w)
            (scan-at ?d ?w)
            (memory-free ?r)
        )

        :effect 
        (and
            (carrying-data ?r ?d)
            (not (memory-free ?r))
            (not (scan-at ?d ?w))
        )
    )

    (:action transmit-data
        :parameters 
        (
            ?r - rover
            ?d - data
            ?l - lander
            ?a - astronaut
        )

        :precondition 
        (and
            (belongs-to ?r ?l)
            (carrying-data ?r ?d)

            ; Astronaut must be in the control room
            (astronaut-belongs-to ?a ?l)
            (in-control-room ?a ?l)
        )

        :effect 
        (and
            (data-transmitted ?d ?l)
            (memory-free ?r)
            (not (carrying-data ?r ?d))
        )
    )
    (:action collect-sample
        :parameters 
        (
            ?r - rover
            ?s - sample
            ?w - waypoint
        )

        :precondition 
        (and
            (deployed ?r)
            (at ?r ?w)
            (sample-at ?s ?w)
            (sample-capacity-free ?r)
        )

        :effect 
        (and
            (carrying-sample ?r ?s)
            (not (sample-at ?s ?w))
            (not (sample-capacity-free ?r))
        )
    )

    (:action store-sample
        :parameters 
        (
            ?r - rover
            ?s - sample
            ?l - lander
            ?w - waypoint
            ?a - astronaut
        )

        :precondition 
        (and
            (belongs-to ?r ?l)
            (at ?r ?w)
            (lander-at ?l ?w)
            (carrying-sample ?r ?s)
            (lander-storage-free ?l)

            ; Astronaut must be in the docking bay
            (astronaut-belongs-to ?a ?l)
            (in-docking-bay ?a ?l)
        )

        :effect 
        (and
            (sample-stored ?s ?l)
            (sample-capacity-free ?r)
            (not (carrying-sample ?r ?s))
            (not (lander-storage-free ?l))
        )
    )

    (:action move-to-control-room
        :parameters 
        (
            ?a - astronaut
            ?l - lander
        )

        :precondition 
        (and
            (astronaut-belongs-to ?a ?l)
            (in-docking-bay ?a ?l)
        )

        :effect 
        (and
            (in-control-room ?a ?l)
            (not (in-docking-bay ?a ?l))
        )
    )

    (:action move-to-docking-bay
        :parameters 
        (
            ?a - astronaut
            ?l - lander
        )

        :precondition 
        (and
            (astronaut-belongs-to ?a ?l)
            (in-control-room ?a ?l)
        )

        :effect 
        (and
            (in-docking-bay ?a ?l)
            (not (in-control-room ?a ?l))
        )
    )
)