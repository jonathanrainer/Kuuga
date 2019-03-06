module trace_assisted_cache(
    input bit clk,
    input bit rst_n
);
    
    dm_cache_fsm standard_cache(
        .clk(clk),
        .rst(rst_n)
    );
    
    
endmodule
