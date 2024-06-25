#import "@preview/polylux:0.3.1": *
#import "@preview/fontawesome:0.1.0": *

#import themes.metropolis: *

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  footer: [Plenaria Commonwears 2024],
)

#set text(font: "Inter", weight: "light", size: 20pt)
#show math.equation: set text(font: "Fira Math")
#set strong(delta: 350)
#set par(justify: true)

#set raw(tab-size: 4)
#show raw.where(block: true): block.with(
  fill: luma(240),
  inset: 1em,
  radius: 0.7em,
  width: 100%,
)

#set table.hline(stroke: .6pt)

#title-slide(
  title: "Pulverisation and Beyond",
  // subtitle: "Subtitle",
  author: "Nicolas Farabegoli",
  date: datetime.today().display("[day] [month repr:long] [year]"),
)

#new-section-slide("Enhanced Pulverisation Evaluation")

#slide(title: "Dynamic Reconfiguration")[
  #table(
    columns: 2,
    inset: 0.65em,
    stroke: none,
    [
      We evaluated _PulvReAKt_ in a simulated _large-scale city event_ where the user were equipped with a smartphone.

      Via *pulverisation* we moved the $#math.beta$ from the cloud and the devices based on the smartphone charge threshold.

      #alert[We improved the simulation introducing more heterogeneity and improving the consumption model.]
    ],
    [
      #figure(
        image("figures/simulation-screenshot-poi.png")
      )
    ]
  )
]

#slide(title: "Improved Power Consumption Model")[
  #align(center)[
    #table(
        columns: 3,
        align: (left, center, center),
        stroke: (x: none),
        inset: 0.65em,
        row-gutter: (2.2pt, auto),
        fill: (x, y) => if y == 4 or y ==5 { rgb("FAAB3630") },
        table.header(
          [*Device*],
          [*Allocated Components*],
          [*Avg. Drain Time*],
        ),
        table.cell(rowspan: 3)[_Smartphone_], [$#math.beta + #math.sigma + #math.chi +$ _OS_], [6h],
        [$#math.beta + #math.chi +$ _OS_], [10h],
        [_OS_], [24h],
        table.cell(rowspan: 2)[_Wearable_], [$#math.sigma + #math.chi +$ _OS_], [6h],
        [_OS_], [24h],
    )
  ]
]

#slide(title: "Simulation Parameters")[
  #align(center)[
    #table(
        columns: 2,
        align: (left, left),
        stroke: (x: none),
        inset: 0.65em,
        row-gutter: (2.2pt, auto),
        fill: (x, y) => if y == 3 { rgb("FAAB3630") },
        table.header(
          [*Simulation Parameter*],
          [*Values*],
        ),
        [_PoIs_], [$15$],
        [$#math.beta$ Offloadin Thresholds], [$scripts(#sym.arrow.t.b.double)_x | x #math.in {0, 10, 20, 30, 40, 100}$],
        [$#math.sigma$ Offloading Policies], [smartphone, wearable, hybrid],
        [Device Count], [$300$],
        [Random Seed], [$0, 1, #math.dots, 1000$],
    )
  ]
]

#slide(title: "(Improved) Results")[
  #align(center)[#text(size: 0.85em)[Traveled Distance (last 30 minutes)]]
  #figure(
    image("figures/travel_distance.svg")
  )

  The *hybrid* policy enables the user to travel longer distances before the battery runs out.
  The *wearable* only policy makes vane the $#math.beta$ thresholds reulting in the worst performance.
]

#slide(title: "(Improved) Results")[
  #table(
    columns: 3,
    stroke: none,
    inset: 0.35em,
    [
      #align(center)[#text(size: 0.85em)[Charging Time]]
      #figure(
        image("figures/charging_time.svg")
      )
    ],
    [
      #align(center)[#text(size: 0.85em)[Cloud Cost]]
      #figure(
        image("figures/cloud_cost.svg")
      )
    ],
    [
      #align(center)[#text(size: 0.85em)[Power Consumption]]
      #figure(
        image("figures/power_consumption.svg")
      )
    ],
  )
  The *wearable* only allocation is the worst (discharge faster).
  The *hybrid* policy performs visibly better when when no other compensation strategy is in place.
  It becomes less significant when behavior offloading is enabled: the _cloud compensate_ similarly for battery discharge (but at a higher cost).
]

#new-section-slide("Macro-program Partitioning")

#slide(title: "Motivation")[
  In the *ECC* we must deal with heterogeneity and different device capabilities.
  #figure(
    image("figures/ecc.svg", width: 80%)
  )

  A _macro-program_ partitioning is needed to cope with device capabilities (e.g resources constraints, sensors availability),
  or simply for improve the system performance.
]

#slide(title: "Research Questions")[
  - _RQ1_: *_How can a macro-programmed system with local and collective services be modularised to favour its deployment on heterogeneous multi-tier infrastructures?_*
  - _RQ2_: *_How can execution be coordinated to preserve the functional correctness at the system-level (w.r.t. the deployment of a monolithic macro-program)?_*
  - _RQ3_: *_Does the approach offer non-functional benefits?_*
]
#slide(title: "Partitioning Model")[
  = System Model
  - _Physical System_: a network of *phisical devices* capable of exchanging data according to a _physical neighbourhood_ relation
  - _Macro-program_: the application logic executed by a subset of the _physical devices_ called *application devices*
  - _Infrastructural devices_: a subset of the _physical devices_ that *can support the execution* of some computation on behalf of some application devices
]

#slide(title: "Partitioning Model")[
  = Macro-programming Model
  - _Macro-program as a DAG_: the macro-program is a set of *components* connected each other via *bindings*
  - _Component_: atomic functional macro-prigram taking a *list of inputs* and producing a *sinle output*; such values are received and produced via *ports*
  - _Binding_: indicates that the output _port_ of a component is connected to one or more input _ports_ of other components
  - _Collective Components_: if *requires the interaction* with instances of the same component in *neighbours devices*
  - _Local Component_: if execution is just a transformation of *local* inputs to *local* outputs
]

#slide(title: "Partitioned Macro-program")[
  #figure(
    image("figures/macro-system-definition-2.svg")
  )
]

#slide(title: "Forward Reference")[
  There may be the case in which an _application device_ cannot execute all the components instances of the macro-program.

  In this case, the component instance must be *forwarded* to an _infrastructural device_.

  Such *forwarding* can be iterative determining a *forwarding chain* from the owner (i.e. the _application device_) to the surrogate _infrastructural device_.
]

#slide(title: "Deployment Perspective")[
  #figure(
    image("figures/deployment-mapping-diagram.svg")
  )
]

#slide(title: "Deployment Independence and Self-stabilisation")[
  We provided a formal definition of the model via an operational semantics,
  and we proved that the model supports *deployment independence* and *self-stabilisation*.

  == Simulation setup
  We simulated a rescue scenario in a _city event_ with real GPS traces empirically prove _functional correctness_ and _non-functional benefits_ (_RQ2 and RQ3_).
]

#slide(title: "Evaluation: Functional Correctness")[
  #figure(
    image("figures/gradient_convergence.svg")
  )
  #figure(
    image("figures/gradient_convergence_error.svg")
  )
]

#slide(title: "Evaluation: Power Consumption and Message Overhead")[
  #figure(
    image("figures/power_consumption_modularisation.svg")
  )

  The modularised approach, while increasing the message overhead,
  reduces the power consumption of the battery.
]

