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
        
        ; Directed waypoint connectivity
        (connected ?from - waypoint ?to - waypoint)

        ; Data acquisition locations and types
        (image-at ?d - data ?w - waypoint)
        (scan-at ?d - data ?w - waypoint)

        ; Rover memory
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