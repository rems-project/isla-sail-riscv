RISCV Sail Model
================

This repository contains a model of the RISCV architecture written in
[Sail](https://www.cl.cam.ac.uk/~pes20/sail/). It used to be contained
in the [Sail repository](https://github.com/rems-project/sail).

It currently implements enough of RV32IMAC and RV64IMAC to boot a
conventional OS with a terminal output device.  The model specifies
assembly language formats of the instructions, the corresponding
encoders and decoders, and the instruction semantics.

Directory Structure
-------------------

```
sail-riscv
|
+---- model                   // Sail specification modules
|
+---- generated_definitions   // Files generated by Sail, in RV32 and RV64 subdirectories
|     |
|     +---- c
|     +---- ocaml
|     +---- lem
|     +---- isabelle
|     +---- coq
|     +---- hol4
|     +---- latex
|
|---- handwritten_support     // Prover support files
|
+---- c_emulator              // supporting platform files for C emulator
+---- ocaml_emulator          // supporting platform files for OCaml emulator
|
+---- doc                     // documentation, including a reading-guide
|
+---- test                    // test files
|     |
|     +---- riscv-tests       // snapshot of tests from the riscv/riscv-tests github repo
|
+---- os-boot                 // information and sample files for booting OS images
```

Documentation
-------------

A [reading guide](doc/ReadingGuide.md) to the model is provided in the
[doc/](doc/) subdirectory, along with a guide on [how to
extend](doc/ExtendingGuide.md) the model.

Simulators
----------

The files in the OCaml and C simulators implement ELF-loading and the
platform devices, define the physical memory map, and use command-line
options to select implementation-specific ISA choices.

Provers
-------

The files under `handwritten_support` provide library definitions for
Coq, Isabelle and HOL4.

Building the model
------------------

Install Sail via Opam, or build Sail from source and have `SAIL_DIR` in
your environment pointing to its top-level directory.

```
$ make
```
will build the 64-bit OCaml simulator in
`ocaml_emulator/riscv_ocaml_sim_RV64`, the C simulator in
`c_emulator/riscv_sim_RV64`, the Isabelle model in
`generated_definitions/isabelle/RV64/Riscv.thy`, the Coq model in
`generated_definitions/coq/RV64/riscv.v`, and the HOL4 model in
`generated_definitions/hol4/RV64/riscvScript.sml`.

One can build either the RV32 or the RV64 model by specifying
`ARCH=RV32` or `ARCH=RV64` on the `make` line, and using the matching
target suffix.  RV64 is built by default, but the RV32 model can be
built using:

```
$ ARCH=RV32 make
```

which creates the 32-bit OCaml simulator in
`ocaml_emulator/riscv_ocaml_sim_RV32`, and the C simulator in
`c_emulator/riscv_sim_RV32`, and the prover models in the
corresponding `RV32` subdirectories.

The Makefile targets `riscv_isa_build`, `riscv_coq_build`, and
`riscv_hol_build` invoke the respective prover to process the
definitions.  We have tested Isabelle 2018, Coq 8.8.1, and HOL4
Kananaskis-12.  When building these targets, please make sure the
corresponding prover libraries in the Sail directory
(`$SAIL_DIR/lib/$prover`) are up-to-date and built, e.g. by running
`make` in those directories.

Executing test binaries
-----------------------

The C and OCaml simulators can be used to execute small test binaries.

```
$ ./ocaml_emulator/riscv_ocaml_sim_<arch>  <elf-file>
$ ./c_emulator/riscv_sim_<arch> <elf-file>
```

A suite of RV32 and RV64 test programs derived from the
[`riscv-tests`](https://github.com/riscv/riscv-tests) test-suite is
included under [test/riscv-tests/](test/riscv-tests/).  The test-suite
can be run using `test/run_tests.sh`.

Configuring platform options
----------------------------

Some information on additional configuration options for each
simulator is available from `./ocaml_emulator/riscv_ocaml_sim_<arch>
-h` and `./c_emulator/riscv_sim_<arch> -h`.

Some useful options are: configuring whether misaligned accesses trap
(`--enable-misaligned` for C and `-enable-misaligned` for OCaml), and
whether page-table walks update PTE bits (`--enable-dirty-update` for C
and `-enable-dirty-update` for OCaml).

Booting OS images
-----------------

For booting operating system images, see the information under the
[os-boot/](os-boot/) subdirectory.


Funding
-------

This software was developed by SRI International and the University of
Cambridge Computer Laboratory (Department of Computer Science and
Technology) under DARPA/AFRL contract FA8650-18-C-7809 ("CIFV"), and
under DARPA contract HR0011-18-C-0016 ("ECATS") as part of the DARPA
SSITH research programme.

This software was developed within the Rigorous
Engineering of Mainstream Systems (REMS) project, partly funded by
EPSRC grant EP/K008528/1, at the Universities of Cambridge and
Edinburgh.
