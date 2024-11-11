/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */
#include "alt_types.h"
#include <stdio.h>
#include "inc/uart.h"
#include "inc/usmart.h"
#include <sys/unistd.h>
#include "inc/motor.h"

int main()
{
  uart_init();

  printf("\r\n=================init begin!===================\r\n");
  motor_init();

  printf("Hello from Nios II!\r\n");
  while(1){
	  usleep(100000);
	  usmart_scan();
  }
  return 0;
}
