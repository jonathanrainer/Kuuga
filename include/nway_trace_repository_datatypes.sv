package nway_trace_repository_datatypes;

import gouram_datatypes::*;
import nway_cache_def::*;

    parameter int TRACE_ENTRIES = 131072;

    typedef struct packed {
	bit [INSTR_DATA_WIDTH-1:0] instruction;
	bit [DATA_ADDR_WIDTH-1:0] mem_addr;
    } trace_repo_data_entry;

    enum bit [1:0] {
        MAKE_REQUEST,
        WAIT_FOR_PROCESSING,
        REQUEST_RETIRED
    } mem_action;

    typedef struct packed {
	bit [$clog2(TRACE_ENTRIES)-1:0] trace_index;
  	bit [DATA_ADDR_WIDTH-1:0] mem_addr;
    } active_set_entry;

    typedef struct packed {
	bit occupied;
	bit [DATA_ADDR_WIDTH-1:0] mem_addr;
	bit processing;
	bit [$clog2(TRACE_ENTRIES)-1:0] trace_index;
    } cache_tracker_t;

endpackage : nway_trace_repository_datatypes
