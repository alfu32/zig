#ifndef ZIG_CLI_H
#define ZIG_CLI_H

#ifdef __cplusplus
extern "C" {
#endif

/* Run the Zig CLI with argv supplied by the caller and the host process
 * environment and standard streams. Returns the CLI status when it returns;
 * 2 means invalid arguments and 3 means another invocation is active. Only
 * one invocation may run at a time. CLI fatal errors retain Zig's normal
 * process-terminating behavior. */
int zig_cli_main(int argc, const char *const argv[]);

#ifdef __cplusplus
}
#endif

#endif
