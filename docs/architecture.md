# Архітектура Noxtyr

## Компоненти

### 1. Java Backend (a.java)
- Entity: HP/Stamina/Attack/Defense
- State Machine: IDLE=0, ATTACK=2, STUN=3, DEATH=4
- Buff System: Bit-mask (тип|тривалість|значення)

### 2. HTML5 Прототип (index.html)
- Player: Константин, комбо-система, ролл
- Enemies: Skeleton AI (warrior/archer)
- Particles: Кров, кістки, ефекти

### 3. Godot Target
- Клас Unit (GDScript)
- Сцена CombatManager
- Android UI

## Портовано
- [x] HTML5 прототип
- [ ] GDScript Unit клас
- [ ] Баф-система

