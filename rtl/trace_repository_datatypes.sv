package trace_repository_datatypes;

import gouram_datatypes::*;

    typedef struct packed {
        trace_format trace_entry;
        bit processing;
        bit retired;   
    } trace_repo_entry;

    enum bit [1:0] {
        MAKE_REQUEST,
        WAIT_FOR_PROCESSING,
        REQUEST_RETIRED
    } mem_action;

endpackage : trace_repository_datatypes