$include <elf.sail>

function main () : unit -> unit = {
  // initialize extensions
  ext_init ();

  mstatus->MPRV() = 0b0;

  PC = to_bits(sizeof(xlen), elf_entry());
  //PC = sail_zero_extend(0x1000, sizeof(xlen));
  print_bits("PC = ", PC);

  try {
    init_model();
    check_cycle_count();
    loop()
  } catch {
    Error_not_implemented(s) => print_string("Error: Not implemented: ", s),
    Error_internal_error() => print("Error: internal error")
  }
}

$ifdef SYMBOLIC

val isla_footprint : forall 'n, 'n in {16, 32}. bits('n) -> bool

function isla_footprint(opcode) = {
  ext_init ();

  mstatus->MPRV() = 0b0;

  try {
    init_model();

    check_cycle_count();
    let ast: ast = if length(opcode) == 16 then {
      decodeCompressed(opcode)
    } else {
      decode(opcode)
    };
    let _ = execute(ext_post_decode_hook(ast));

    true
  } catch {
    _ => false
  }
}

$endif
