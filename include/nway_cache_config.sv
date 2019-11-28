package nway_cache_def;
    // Data structure for cache tag & data
    
    parameter int TAGMSB = 31; // Tag MSB
    parameter int TAGLSB = 4; // Tag LSB
    parameter int SETMSB = 3;
    parameter int SETLSB = 0;
    parameter int CACHE_BLOCKS = 128;
    
    // Data structure for cache tag
    typedef struct packed {
        bit                 valid;  // Valid Bit
        bit                 dirty;  // Dirty Bit
        bit [TAGMSB-TAGLSB:0] tag;    // Tag Bits
	bit [$clog2(CACHE_BLOCKS)-1:0] cache_index;
    } cache_tag_type;
    
    // Data structure for cache memory request
    typedef struct {
        bit [SETMSB:SETLSB]   set;  // 4 Bit Set (16 Sets, 8 Slots per Set, 128 Blocks overall)
	bit [TAGMSB-TAGLSB:0]   tag_to_find;
        bit         we;     // Write enable
    } cache_tag_req_type;

    // Data structure for cache memory request
    typedef struct {
        bit [$clog2(CACHE_BLOCKS)-1:0]   cache_index;  // 7-bit index
        bit         we;     // Write enable
    } cache_data_req_type;
    
    // 32-bit cache line data
    typedef bit [31:0] cache_data_type;
    
    // Data structures for CPU<->Cache Controller Interface
    
    // CPU Request (CPU->Cache Controller)
    typedef struct {
        bit [31:0] addr;    // 16-bit request addr
        bit [31:0] data;    // 32-bit request data (used when write)
        bit rw;             // Request type: 0 = read, 1 = write
        bit valid;          // Request is valid
    } cpu_req_type;
    
    // Cache Result (Cache Controller->CPU)
    typedef struct {
        bit [31:0] data;    // 32-bit data
        bit ready;          // Result is ready
        bit checked;        // Is the result final?
	bit [$clog2(CACHE_BLOCKS)-1:0] cache_index;
    } cpu_result_type;
    
    //--------------------------------------------------------------------
    // Data structures for Cache Controller <-> Memory Interface
    
    // Memory Request (Cache Controller -> Memory)
    typedef struct {
        bit [31:0]  addr;   // Request byte addr
        bit [31:0] data;   // 32-bit request data (used when write)
        bit rw;             // Request Type: 0 = read, 1 write    
        bit valid;          // Request is valid
    } mem_req_type; 
    
    // Memory controller response (Memory -> Cache Controller)
    typedef struct {
        cache_data_type data;   // 128-bit read back data
        bit ready;              // Data is ready
    } mem_data_type;
    
endpackage
