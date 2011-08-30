/**
 * The_stalker
 *
 * kr3l - kr3l.wordpress.org
 *
 * use code as you please, but at own risk :-)
 */


#include <dwengoConfig.h>
#include <dwengoBoard.h>
#include <dwengoDelay.h>
#include <dwengoLCD.h>

void switchPower() {
    PORTAbits.RA0 = LOW;
    delay_ms(1000);
    PORTAbits.RA0 = HIGH;
    delay_ms(1000);
    clearLCD();
}
void switchRec() {
    PORTAbits.RA1 = HIGH;
    delay_ms(1000);
    PORTAbits.RA1 = LOW;
    delay_ms(1000);
    clearLCD();
}
void main(void) {
  unsigned char counter;
  BYTE camera_on = FALSE;
  BYTE camera_rec = FALSE;
  BYTE sw_e_prev = FALSE;
  BYTE sw_w_prev = FALSE;
  TRISA = OUTPUT;
  initBoard();
  initLCD();
  clearLCD();
  backlightOn();
  setCursorLCD(0,0);
  appendStringToLCD("The Stalker");
  setCursorLCD(1, 0);
  appendStringToLCD("...........");
  while (TRUE) {
      if (SW_E == PRESSED) {
          sw_e_prev = TRUE;
      } else if (sw_e_prev == TRUE) {   //SW_E key up
            sw_e_prev = FALSE;
            clearLCD();
            setCursorLCD(0,0);
            if (camera_on == TRUE) {
                appendStringToLCD("Shut down cam");
                camera_on = FALSE;
            } else {
                appendStringToLCD("Power up cam");
                camera_on = TRUE;
            }
            switchPower();
      }

      if (SW_W == PRESSED) {
          sw_w_prev = TRUE;
      } else if (sw_w_prev == TRUE) {   //SW_E key up
            sw_w_prev = FALSE;
            clearLCD();
            setCursorLCD(0,0);
            if (camera_rec == TRUE) {
                appendStringToLCD("Stop rec");
                camera_rec = FALSE;
            } else {
                appendStringToLCD("Start rec");
                camera_rec = TRUE;
            }
            switchRec();
      }

      delay_ms(200);
  }
}
