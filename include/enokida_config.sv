package cache_def;
    // Data structure for cache tag & data
    
    parameter int TAGMSB = 15; // Tag MSB
    parameter int TAGLSB = 6; // Tag LSB
    parameter int INDEXMSB = 5;
    parameter int INDEXLSB = 0;
    
    // Data structure for cache tag
    typedef struct packed {
        bit                 valid;  // Valid Bit
        bit                 dirty;  // Dirty Bit
        bit [TAGMSB:TAGLSB] tag;    // Tag Bits   
    } cache_tag_type;
    
    // Data structure for cache memory request
    typedef struct {
        bit [INDEXMSB:INDEXLSB]   index;  // 7-bit index (128 blocks)
        bit         we;     // Write enable
    } cache_req_type;
    
    // 32-bit cache line data
    typedef bit [31:0] cache_data_type;
    
    // Data structures for CPU<->Cache Controller Interface
    
    // CPU Request (CPU->Cache Controller)
    typedef struct {
        bit [15:0] addr;    // 16-bit request addr
        bit [31:0] data;    // 32-bit request data (used when write)
        bit rw;             // Request type: 0 = read, 1 = write
        bit valid;          // Request is valid
    } cpu_req_type;
    
    // Cache Result (Cache Controller->CPU)
    typedef struct {
        bit [31:0] data;    // 32-bit data
        bit ready;          // Result is ready
        bit checked;        // Is the result final?
    } cpu_result_type;
    
    //--------------------------------------------------------------------
    // Data structures for Cache Controller <-> Memory Interface
    
    // Memory Request (Cache Controller -> Memory)
    typedef struct {
        bit [15:0]  addr;   // Request byte addr
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
