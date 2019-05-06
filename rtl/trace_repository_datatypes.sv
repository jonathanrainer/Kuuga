package trace_repository_datatypes;

import gouram_datatypes::*;
import cache_def::*;

    parameter int TRACE_INDEXES_STORED = 256;
    parameter int TRACE_ENTRIES = 2048;

    typedef struct packed {
	bit [INSTR_DATA_WIDTH-1:0] instruction;
	bit [DATA_ADDR_WIDTH-1:0] mem_addr;
    } trace_repo_data_entry;

    typedef struct packed {
        trace_repo_data_entry trace_entry;
        bit processing;
        bit retired;   
    } trace_repo_entry;

    enum bit [1:0] {
        MAKE_REQUEST,
        WAIT_FOR_PROCESSING,
        REQUEST_RETIRED
    } mem_action;

    typedef struct packed {
	bit [$clog2(TRACE_ENTRIES)-1:0] trace_index;
	trace_repo_data_entry trace_entry;
	bit processing;
    } active_set_entry;


endpackage : trace_repository_datatypes
