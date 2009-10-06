package Games::SMTNocturne::Fusion::Role::Special;
use Moose::Role;
use namespace::autoclean;
with 'Games::SMTNocturne::Fusion::Role::NotNormallyFusable';

1;

__DATA__
---
Amaterasu:
  demon1:
  - Yatagarasu
  demon2:
  - Mikazuchi
  sacrifice:
  - Uzume
Gabriel:
  demon1:
  - Throne
  demon2:
  - Raphael
Girimehkala:
  sacrifice:
  - type
  - Vile
  target:
  - Purski
Gurr:
  sacrifice:
  - type
  - Tyrant
  target:
  - Sparna
Metatron:
  demon1:
  - Michael
  demon2:
  - type
  - - Divine
    - Seraph
  sacrifice:
  - type
  - Tyrant
Michael:
  demon1:
  - Uriel
  demon2:
  - Gabriel
  demon3:
  - Raphael
Ongyo-ki:
  demon1:
  - Kin-Ki
  demon2:
  - Sui-Ki
  demon3:
  - Fuu-Ki
Raphael:
  demon1:
  - Dominion
  demon2:
  - Uriel
Sakahagi:
  fusion_type:
  - Element
  target:
  - Sakahagi
Samael:
  sacrifice:
  - type
  - Vile
  target:
  - Throne
Shiva:
  demon1:
  - Ragnda
  demon2:
  - Barong
