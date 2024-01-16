# Simulator of multitape Turing machine.

Multitape Turing Machine Simulator.
A Turing machine is a mathematical model of computation describing an abstract machine, that manipulates symbols on a strip of tape according to a table of rules. Despite the model's simplicity, it is capable of implementing any computer algorithm.

The machine operates on a memory tape divided into cells, each of which can hold a single symbol drawn from symbols from the alphabet of the machine. It has a "head" that, at any point in the machine's operation, is positioned over one of these cells, and a "state" selected from a set of states. At each step of its operation, the head reads the symbol in its cell. Then, based on the symbol and the machine's own present state, the machine writes a symbol into the same cell, and moves the head one step to the left or the right, or halts the computation. The choice of which replacement symbol to write and which direction to move is based on a table that specifies what to do for each combination of the current state and the symbol that is read.

[Learn what is Turing Machine](https://en.wikipedia.org/wiki/Turing_machine#:~:text=A%20Turing%20machine%20is%20a,A%20physical%20Turing%20machine%20model.).

## Layers

- Core (DI, Extensions, Persistence) 
- Domain (Models, Repositories' Interfaces)
- Data (Repositories' Implementations)
- Presentation Layer (Views, ViewModels, Models)

## Technologies used

- Clean Architecture
- MVVM+C
- SwiftUI
- CoreData
- Swinject (Dependency Injection framework)
- Combine
- SwiftLint
- Data Transfer Object (DTO)
- Coordinator Pattern
- Custom Logger


## Features

- Folder (A container for organizing algorithms, providing a way to group related algorithms together)
- Algorithm (Represents a computational process or set of rules to be followed within a folder)
- Tape (Represents a tape used in the computation, providing a medium for input and output)
- Maching State (Represents a state within the state machine of an algorithm, defining the possible transitions)
- Option (Represents an option within a machine state, defining a possible transition with specific combinations)
- Combination (Represents a specific combination of input characters and actions within an option)

## Preview

https://github.com/SnowLukin/TuringMachineSimulator/assets/69481493/a50c6d1d-a19f-476d-94ae-9d6eae91d8a7

## App Requirements

- iOS 16+
