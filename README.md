# PROBABLE FACTORS:
https://www.youtube.com/watch?v=caHvkIa4Jwc
## Team Members:
- Walter Jiang
- Leonardo Falvo
- Zhengcheng Geng

### Walter Jiang:
- Made factors and GCD main functions
- Made slideshow and video
- Helped debug Miller-Rabin and Pollards Rho functions

### Leonardo Falvo:
- Made Pollard's rho function
- Benchmarked for different values of x using core_bench
- Encoded integers with the Zarith library to allow for very large integers
- Wrote script for video

### Zhengcheng Geng:
- Made Miller-Rabin function
- Made problem description pdf

We give permission to share this project. 

## Project Details

The main file for this project is `factor.ml`. `factor.ml` uses three libraries available through the opam: Zarith, core, and core_bench.

We tried to not use any libraries for this project, simply making use of the `Int64` type built in to OCaml, but because our project explicitly addresses very large integers we had to use Zarith. Core and core_bench are how we generated the graphs of time at given values.

### Installation and Setup

I assume the grader of this assignment will be able to install these packages and then run the program, but if a refresher is needed:

1. **Install OCaml**: Follow the guide at [ocaml.org/docs/up-and-running](https://ocaml.org/docs/up-and-running). Verify installation with `ocaml --version`.
2. **Install OPAM**: Follow instructions at [opam.ocaml.org/doc/Install.html](https://opam.ocaml.org/doc/Install.html). Initialize with `opam init && eval $(opam env)`.
3. **Install required packages**: Run `opam install dune core core_bench zarith`.
4. **Build the project**: Run `dune build`.
5. **Run executables**: Use `dune exec ./factor.exe` or `dune exec ./factor_template.exe`.
6. **To update changes**: Run `dune clean` and then `dune build`.

## Benchmarking Process

In order to create the benchmark graphs for our OCaml project, we piped the results of core_bench into the file: `final_benches`. Using the file `plotting.py` we parsed and graphed the results of this.

Because computing all of these factors takes a long time, random large values were computed in order to get a roughly representative sample of runtime.

**Note**: Benchmarking was started and stopped several times, so `final_benches.txt` is not a particularly clean file. Consider `final_benches.txt` and `plotting.py` proof that these graphs were generated with a rigorous benchmarking program and not randomly generated. I do not recommend rerunning these tests as they are very time-intensive.
