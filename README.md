# EnergyZeroViewer

This application calls the EnergyZero api in order to get the daily cost of gas and electricity in the Netherlands. This is especially helpful to customers of ANWB since their prices are the same as the prices listed in the EnergyZero api.

## Installation

Run `mix escript.build`. This will create the `energy_zero_viewer` binary.

## Usage

Run either `./energy_zero_viewer --usage electricity` or `./energy_zero_viewer --usage gas`.
