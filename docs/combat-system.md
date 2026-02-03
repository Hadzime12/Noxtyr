# Бойова система Noxtyr

## Статистика юніта

| Поле | Тип | Опис |
|------|-----|------|
| unit_id | int | ID типу з бази |
| hp_current | int | Поточне HP |
| stamina | int | Енергія/витривалість |

## State Machine
```gdscript
enum State {
    IDLE = 0,
    ATTACK = 2,
    STUN = 3,
    DEATH = 4
}

