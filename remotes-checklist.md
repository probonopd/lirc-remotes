# Remote configuration file checklist.

## MUST:

  - Device must not be present in
    [remotes directory](http://lirc.sourceforge.net/remotes)

  - Each config file should correspond to one physical device.

  - All data supplied?

    + Kernel revision (uname -r)

    + irrecord --driver and --device option used.

    + Name of remote device, the thing you hold in your hand.

    + Does remote device has a bundled capture device e. g., a usb
      dongle?

    + For bundled USB capture  devices: usb vendor id, product id and
      device string (using dmesg or lsusb).

    + Type of device controlled (TV, VCR, Audio, DVD, Satellite, Cable,
      PVR, HTPC, ...)

    + Device(s) controlled.

    + Remote layout (ascii art showing symbol for each button).

  - Config file should use proper name symbols from namespace where
    applicable (use lirc-config-tool -sc to check status).

  - Files with raw data should if possible be converted using
    irrecord -a

  - The toggle_bit_mask should be non-zero if RC5, RC6 or RCMM is in flags.
    If not try with the default values:
        + 0x800 for RC5 protocol.
        + 0x8000 or 0x10000 for RC6 and RCMM protocol.


## SHOULD:

 - Photo of remote (scale to ~100 kb).

 - Is there any known kernel configuration e. g., blacklisted kernel
   modules or specific kernel drivers?

 - URL with remote device information.

 - If the remote can be decoded in different ways e. g., like
   intelligent, multi-purpose devices,  several remote definitions
   should be put in the config file.



## NOTES:

### Key symbols
 + Use key symbols from namespace when there's a reasonable alternative.
 + When using non-standard symbols, do *not* use the KEY_ prefix. A
   symbol prefixed with KEY_ is supposed to be a standard symbol.
 + For mouse clicks use BTN_LEFT, BTN_RIGHT
 + For mouse movements use MOUSE_N, MOUSE_S, MOUSE_NW, MOUSE_SE, etc.
 + KEY_RED..KEY_BLUE is preferred to KEY_A..KEY_D.

lirc-config-tool -sc scans file for "bad" symbols. lirc-config-tool -uc can
update many ad-hoc symbols using heuristics - results must be checked!

###    Remote sketch

Can be done like this:

    # +---------------------------------------+
    # |                                       |
    # |  VIDEO   AUDIO   MUTE   (POWER)       |
    # |                                       |
    # |  Lnb     RADIO   Mono/   Ext          |
    # |                   st                  |
    # | (  1  ) (  2  ) (  3  )  Status       |
    # |                                       |
    # | (  4  ) (  5  ) (  6  )  Store        |
    # |                                       |
    # | (  7  ) (  8  ) (  9  )  Recall       |
    # |                                       |
    # |         (  0  ) (+100 )  LIST         |
    # |                                       |
    # |  SLEEP   Afc  CHANNELUP  10CHANNELS   |
    # !                          DOWN
    # |                                       |
    # |  Timer   Head   CHANNEL  10CHANNELSUP |
    # |          phone  DOWN                  |
    # |                                       |
    # +---------------------------------------+

Or like this:

    #    ---------------------------------
    #   / X                               \  POWER
    #   |                                 |
    #   | X                            X  |  BACK, MENU
    #   |                                 |
    #   |                X                |  UP
    #   |                                 |
    #   |         X      X     X          |  LEFT, OK, RIGHT
    #   |                                 |
    #   |                X                |  DOWN
    #   |                                 |
    #   | X                            X  |  SEARCH, Fullscreen
    #   |                                 |
    #   |        X   X   X   X   X        |  ORANGE, YELLOW, GREEN, BLUE, Purple
    #   |                                 |
    #   |                X                |  HOME
    #   \                                 /
    #    ---------------------------------


###    Examples made according to new standards:

  - [samsung/AA59-00600A.conf](http://lirc.sourceforge.net/remotes/samsung/AA59-00600A.conf)




