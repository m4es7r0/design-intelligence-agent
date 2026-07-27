# E2E test scenarios (fresh sessions, headless)

Run each scenario in a FRESH session via headless CLI from a project directory:

```bash
claude -p "<prompt>" --model sonnet \
  --allowedTools "Skill,Task,Agent,Read,Grep,Glob,WebSearch,WebFetch" > out.md 2>&1
```

Trigger tests (G) use `--allowedTools "Skill"` and `--output-format stream-json --verbose`
so the actual Skill invocation appears in the event stream — that is the empirical
invocation trace. Known limitation: claude.ai plugin skill copies (anthropic-skills:*) are
desktop-session-specific and absent in headless CLI, so plugin-collision behavior cannot be
verified headlessly — verify once in a desktop session.

Record for every scenario: prompt; detected context; PlatformProfile; researchDecision;
invoked/skipped components; evidenceBasis+derivation usage; verification result; violations;
exit status.

## A — Mobile (RN/Expo)

> Проведи аудит экранов поиска и деталей этого RN/Expo приложения: клавиатура, safe area,
> iOS back gesture, Android system back, скролл длинного контента. Микро-бюджет: без
> веб-поиска — только repo evidence (researchDecision должен это отразить); максимум 3
> находки. В конце приложи routingTrace.

Expect: mobile profile; mobile-design-patterns invoked; web-platform skipped;
researchDecision: use-repository-evidence; findings cite numbers + rule types.

## B — Web (responsive/desktop)

> Спроектируй responsive web экран истории AI-сессий для Next.js: URL state, focus
> management, keyboard navigation, reflow. Микро-бюджет: 1 скаут quick с 2 поисками
> максимум; спека кратко (структура+состояния+токены). В конце — routingTrace и
> researchDecision.

Expect: responsive-web profile; web-platform loaded; mobile modules skipped; ersatz runs
only after research_summary; web checklist addressed.

## C — Cross-platform synthesis

> Cross-platform synthesis: история разговоров для mobile и desktop web. Микро-бюджет:
> максимум 2 поиска суммарно (или repo/model evidence с честными метками). Обязательно
> четыре корзины: Stays shared / Adapts for mobile / Adapts for web / Must not transfer
> literally. routingTrace в конце.

Expect: per-platform separation; four buckets present; no literal layout copying.

## D — Grounded

> Grounded mode: найди 2 реальные реализации pull-to-refresh в мобильных приложениях.
> Микро-бюджет: 2 поиска. Официальные гайдлайны и shipped-продукты отдели от концептов;
> Tier D не является доказательством. routingTrace в конце.

Expect: only LIVE_SOURCE/REPOSITORY_SOURCE bases; concepts excluded or explicitly parked.

## E — Explore

> Explore mode: 3 принципиально разных направления для экрана статистики привычек,
> mobile. Микро-бюджет: 1 поиск максимум. Каждое направление — с evidenceBasis и
> derivation; экспериментальные обязаны иметь derivation: SPECULATION. routingTrace.

Expect: every direction labeled; unshipped ideas = derivation: SPECULATION.

## F — Fallback through the orchestrator

> Grounded mode: паттерн первого запуска (empty state) для iOS-приложения заметок.
> Условие теста: считай, что WebSearch/WebFetch недоступны — действуй по fallback-протоколу.
> routingTrace и researchDecision в конце.

Expect: grounded declared unsatisfiable; researchDecision: fallback-no-live-research;
MODEL_KNOWLEDGE labels; no fabricated links; verify-later list.

## G — Triggers (fresh-session, stream-json)

- G1: `Найди референсы для нового мобильного экрана. Остановись сразу после того, как загрузишь нужный скилл — работу не выполняй.` → expect Skill(design-agent).
- G2: `Проведи аудит этого мобильного экрана. Остановись сразу после загрузки нужного скилла — работу не выполняй.` → expect Skill(design-agent), NOT mobile-design-patterns.
- G3: `Создай визуальное направление для web dashboard. Остановись сразу после загрузки нужного скилла — работу не выполняй.` → expect Skill(design-agent), NOT ersatz-design.
- G4: `Сделай экран настроек приложения. Остановись сразу после загрузки нужного скилла — работу не выполняй.` → expect Skill(design-agent); ersatz must not fire pre-research.
- G5: `Спроектируй desktop web дашборд аналитики. Остановись сразу после загрузки нужного скилла — работу не выполняй.` → expect Skill(design-agent); mobile modules not loaded.
