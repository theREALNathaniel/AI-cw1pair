(define (domain lunar)
    (:requirements :strips :typing)

    ; -------------------------------
    ; Types
    ; -------------------------------

    ; EXAMPLE

    ; (:types
    ;     parent_type
    ;     child_type - parent_type

    ; )
    (:types
        rover
        lander
        waypoint
        data
        sample
    )

    ; -------------------------------
    ; Predicates
    ; -------------------------------

    ; EXAMPLE

    ; (:predicates
    ;     (no_arity_predicate)
    ;     (one_arity_predicate ?p - parameter_type)
    ; )

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
    )

    ; -------------------------------
    ; Actions
    ; -------------------------------

    ; EXAMPLE

    ; (:action action-template
    ;     :parameters (?p - parameter_type)
    ;     :precondition (and
    ;         (one_arity_predicate ?p)
    ;     )
    ;     :effect 
    ;     (and 
    ;         (no_arity_predicate)
    ;         (not (one_arity_predicate ?p))
    ;     )
    ; )

    ; Checks whether the rover is aboard its assigned lander and where the lander is located
    ; If true, deploys the rover at the lander's waypoint and removes its aboard status
    (:action deploy
        :parameters 
        (
            ?r - rover
            ?l - lander
            ?w - waypoint
        )

        :precondition 
        (and
            (aboard ?r ?l)
            (belongs-to ?r ?l)
            (lander-at ?l ?w)
        )

        :effect 
        (and
            (deployed ?r)
            (at ?r ?w)
            (not (aboard ?r ?l))
        )
    )

    ; Checks whether the rover is deployed, its current waypoint and whether
    ; there is a connection from its current waypoint to the destination
    ; If true, updates the rover's location to the destination waypoint
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

    ; Checks whether the rover is deployed, is at the image's waypoint and has free memory
    ; If true, captures the image and stores it in the rover's memory
    ; Removes the image from its waypoint and marks the rover's memory as full
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

    ; Checks whether the rover is deployed, is at the scans waypoint and has free memory
    ; If true, captures the image and stores it in the rover's memory
    ; Removes the scan from its waypoint and marks the rover's memory as full
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

    ; Checks if the rover belongs to a lander and which one and whether the rover is carrying data
    ; If true then sends the data from the rover to it's respective lander
    ; Then sets rover to have memory caspacity to be empty and is not carrying any data
    (:action transmit-data
        :parameters 
        (
            ?r - rover
            ?d - data
            ?l - lander
        )

        :precondition 
        (and
            (belongs-to ?r ?l)
            (carrying-data ?r ?d)
        )

        :effect 
        (and
            (data-transmitted ?d ?l)
            (memory-free ?r)
            (not (carrying-data ?r ?d))
        )
    )

    ; Checks whether the rover is deployed, is at the sample's waypoint
    ; and has free sample-carrying capacity
    ; If true, collects the sample and removes it from its waypoint
    ; Marks the rover as carrying the sample and its sample capacity as full
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

    ; Checks which lander the rover belongs to and whether both are at the same waypoint.
    ; Also checks whether the rover is carrying the sample and the lander has free storage.
    ; If true, stores the sample in the lander, frees the rover's sample capacity
    ; and marks the lander's sample storage as full.
    (:action store-sample
        :parameters 
        (
            ?r - rover
            ?s - sample
            ?l - lander
            ?w - waypoint
        )

        :precondition 
        (and
            (belongs-to ?r ?l)
            (at ?r ?w)
            (lander-at ?l ?w)
            (carrying-sample ?r ?s)
            (lander-storage-free ?l)
        )

        :effect 
        (and
            (sample-stored ?s ?l)
            (sample-capacity-free ?r)
            (not (carrying-sample ?r ?s))
            (not (lander-storage-free ?l))
        )
    )
)