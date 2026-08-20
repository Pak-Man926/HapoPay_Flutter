# HapoPay Student Rewards System

> Implements the layered pattern described in [`ARCHITECTURE.md`](ARCHITECTURE.md); tracked under Milestone 3 in [`NEXT_STEPS.md`](NEXT_STEPS.md).

## Overview
Gamified student rewards: tier progress, streak panel, claimable achievements, and a dashboard summary card. Content and thresholds live in a shared catalog so mock, demo, and UI stay aligned.

## Status
**Client complete** for the redesigned catalog and claim UX. Earning rules are owned by the Django `/api/rewards/` backend; the Flutter app displays state and claims achievements.

## Workflows

### Load rewards (dashboard → full screen)

```mermaid
flowchart TD
  start[StudentDashboard] --> summary[_RewardsSummaryCard]
  summary -->|watch rewardsProvider| load[Rewards.build]
  load --> authCheck{Authenticated studentId?}
  authCheck -->|no| err[StateError snackbar or error UI]
  authCheck -->|yes| repo[RewardsRepository.fetchRewards]
  repo --> dio[Dio GET /rewards/id/]
  dio --> mockGate{USE_MOCK_API?}
  mockGate -->|true| mock[MockInterceptor seed catalog]
  mockGate -->|false| django[Django API]
  mock --> model[RewardModel.fromJson]
  django --> model
  model --> ui[Hero streak ladder achievements]
  summary -->|tap| nav[GoRouter /student/rewards]
  nav --> ui
```

### Claim achievement (optimistic)

```mermaid
flowchart TD
  tap[User taps Claim] --> opt[RewardsCatalog.applyClaim locally]
  opt --> bump[Bump totalPoints recompute tier]
  bump --> ui[UI shows claimed + spinner]
  ui --> post[POST /rewards/id/claim/]
  post --> ok{Server OK?}
  ok -->|yes| reconcile[Replace state with server RewardModel]
  ok -->|no| rollback[Restore prior AsyncData]
  rollback --> snack[Error snackbar]
  reconcile --> success[Success haptic + snackbar]
```

### Tier progression (points → badge)

```mermaid
flowchart LR
  pts[total_points] --> bronze[Bronze 0 to 149]
  bronze -->|150+| silver[Silver 150 to 499]
  silver -->|500+| gold[Gold 500 to 999]
  gold -->|1000+| plat[Platinum 1000+]
```

### Feature data path

```mermaid
flowchart TB
  subgraph presentation [Presentation]
    screen[RewardsScreen]
    card[Dashboard summary card]
  end
  subgraph state [State]
    provider[rewardsProvider]
    catalog[RewardsCatalog]
  end
  subgraph data [Data]
    repo[RewardsRepository]
    dio[DioClient]
  end
  screen --> provider
  card --> provider
  provider --> catalog
  provider --> repo
  repo --> dio
```

## Game design

### Tiers
| Tier | Points |
|------|--------|
| Bronze | 0–149 |
| Silver | 150–499 |
| Gold | 500–999 |
| Platinum | 1000+ |

### Achievements
| ID | Name | Points | Category |
|----|------|--------|----------|
| `first_pay` | First Tap | 25 | Payments |
| `qr_rookie` | QR Rookie | 50 | Payments |
| `qr_pro` | QR Pro | 100 | Payments |
| `campus_champ` | Campus Champ | 200 | Payments |
| `budget_3` | Budget Buddy | 75 | Streak |
| `week_warrior` | Week Warrior | 150 | Streak |
| `month_master` | Month Master | 300 | Streak |
| `smart_spender` | Smart Spender | 100 | Saving |
| `big_buffer` | Big Buffer | 125 | Saving |

Streak milestones shown in UI: 3 / 7 / 14 / 30 days (derived from `streak_days`).

Source of truth: `lib/features/student/models/rewards_catalog.dart`.

## Architecture

- **Catalog**: `rewards_catalog.dart` — tier milestones + achievement definitions + seed helpers
- **Model**: `reward_model.dart` — `RewardTier`, `AchievementModel`, `MilestoneModel`, `RewardModel`
- **Repository**: `rewards_repository.dart` — `GET /rewards/{id}/`, `POST /rewards/{id}/claim/`
- **Provider**: `rewards_provider.dart` — optimistic claim (points + tier), rollback on failure without full-screen error wipe
- **UI**: `rewards_screen.dart` (hero, streak panel, tier ladder with ranges, achievement grid); dashboard `_RewardsSummaryCard`
- **Routing**: `/student/rewards`
- **Mock**: `MockInterceptor` only when `USE_MOCK_API=true` (see [`EnvConfig`](../lib/core/config/env_config.dart))

## API contract

```
GET  /api/rewards/{studentId}/
POST /api/rewards/{studentId}/claim/   body: { "achievement_id": "..." }
```

Response is a full `RewardModel` JSON (`snake_case`). `next_milestone_points` is the **absolute** next-tier threshold (not remaining points).

## Local mock / demo

```bash
# Enable in-memory mock API (includes rewards seed)
flutter run --dart-define-from-file=.env.dev
# .env.dev must set USE_MOCK_API=true
```

`RewardModel.demo()` builds from `RewardsCatalog` for tests and offline fixtures. It is **not** an automatic network fallback — failed fetches surface as provider errors / snackbars.

## How to test
1. Sign in as a student with mock API enabled (or a backend matching the catalog).
2. Open the Rewards summary on the student dashboard → full Rewards screen.
3. Confirm tier ranges, streak week dots, and milestone checks.
4. Claim an earned unclaimed achievement; points and tier should update.
5. Repeat in light and dark themes.
