#include "VDUT.h"
#include "verilated.h"
#include <verilated_vcd_c.h>

int main(int argc, char **argv)
{
    const vluint64_t max_time = 100;
    vluint64_t main_time = 0;
    Verilated::commandArgs(argc, argv);
    VDUT *top = new VDUT;

    VerilatedVcdC *tfp = NULL;
    Verilated::traceEverOn(true); // Verilator must compute traced signals
    VL_PRINTF("Enabling waves into logs/vlt_dump.vcd...\n");
    tfp = new VerilatedVcdC;
    top->trace(tfp, 99); // Trace 99 levels of hierarchy
    Verilated::mkdir("logs");
    tfp->open("logs/vlt_dump.vcd"); // Open the dump file

    while (!Verilated::gotFinish() && (max_time == 0 || main_time <= max_time))
    {
        main_time++;
        // top->clk = !top->clk;
        // Test
        top->A = 452545985588575855LL;
        top->B = 7415585544748885LL;
        // Test

        top->eval();
        if (tfp)
            tfp->dump(main_time);
    }

    top->final();
    if (tfp)
    {
        tfp->close();
        delete tfp;
        tfp = NULL;
    }

    delete top;
    return 0;
}