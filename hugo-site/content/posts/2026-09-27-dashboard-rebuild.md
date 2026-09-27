---
title: "Dashboard Rebuild: Why I Ditched React for HTMX and Regret Nothing"
date: 2026-09-27T12:00:00-05:00
draft: false
tags: ["htmx", "alpinejs", "flask", "dashboard", "homelab"]
---

## The Context

I had a dashboard. It was fine. Then it wasn't. The original stack was vanilla HTML + some janky JavaScript that I wrote in a hurry. It worked until it didn't — specifically, until I wanted it to feel like a real application without turning it into a React bundle the size of a small nation.

## The Decision

Enter **HTMX** and **Alpine.js** — two libraries that combined weigh less than the React logo SVG. The pitch was simple: server-rendered HTML fragments, swapped into the DOM on demand, with just enough client-side interactivity to not feel like 1998.

## What Actually Happened

**The rebuild took a weekend.** Not a "let me scaffold Next.js and configure webpack" weekend. A "I wrote HTML and it worked" weekend.

The architecture ended up being:
- **Flask** serving HTML fragments via Jinja2 templates
- **HTMX** handling all dynamic loading (polling, swaps, actions)
- **Alpine.js** handling client toggles, forms, and animations
- **No build step.** No npm. No node_modules folder that somehow weighs 18MB for a dashboard.

## The Stack

| Component | Size | Purpose |
|-----------|------|---------|
| HTMX | ~14KB | Server fragments, AJAX, polling |
| Alpine.js | ~15KB | Client interactivity, reactive state |
| Vanilla JS | ~3KB | Canvas drawing widget only |

**Total JS overhead: ~29KB.** For comparison, React alone is ~40KB before you add anything that actually does something.

## The Layout

I went with a **border layout** (north, south, west, center, east) because it's a dashboard and dashboards have borders. The center area uses CSS columns masonry with `break-inside: avoid` — a technique so old it's new again.

**Widgets implemented:**
- System Health (CPU temp, load, disk)
- Shoggoth Gauge (animated progress bar, because why not)
- Task List (with actual working checkboxes)
- Vivian's Stream of Consciousness (the AI's thoughts, rendered in real-time)
- Activity Feed (agent activities, polled every 60s)
- Clown Incident Meter (a leaderboard of workplace absurdity)
- Bitcoin Price Chart (SVG sparkline with gradient fill — the prettiest thing on the page)
- Drawing Canvas (vanilla JS, because HTMX can't draw)

## The Bitcoin Chart

This deserves its own paragraph because it's genuinely beautiful. Instead of just showing the current price like every other crypto widget, it fetches hourly candles from Coinbase and renders an SVG sparkline chart showing the day's price movement.

Features:
- Gradient fill under the line
- Pulsing dot at the current price (live indicator)
- Daily change percentage (green for up, red for down)
- Time labels: 00:00 → 06:00 → 12:00 → 18:00 → Now
- Refreshes every 60 seconds, API data cached for 5 minutes

**The entire chart is generated server-side.** The browser receives HTML with an inline SVG. No JavaScript chart library. No D3. No Chart.js. Just a `<svg>` tag with some `<polyline>` elements and a `<linearGradient>`.

## What I Learned

**Server-rendered HTML is not a regression.** For dashboards, admin panels, and content-heavy applications, it's often the right choice. The browser is really good at rendering HTML. We spent a decade convincing ourselves it wasn't.

**HTMX + Alpine is a sweet spot.** HTMX handles what the server should handle. Alpine handles what the browser should handle. They don't fight each other because they have different jobs.

**CSS columns are underrated.** The masonry layout (2 columns on desktop, 1 on mobile) uses `column-count` and `break-inside: avoid`. That's it. No JavaScript masonry library. No complex grid calculations. Just CSS doing what CSS does.

**The absence of a build step is a feature.** I can edit a template, hit refresh, and see changes. No `npm run dev`. No hot module replacement that breaks halfway through. No waiting for a bundler to finish its existential crisis.

## What Sucked

**HTMX polling isn't WebSockets.** For true real-time (like the thought stream), polling every few seconds is fine. For a stock ticker, you'd want SSE or WebSockets. HTMX supports both, but I didn't need them here.

**Alpine.js `x-data` on HTMX-swapped fragments requires careful initialization.** Sometimes Alpine doesn't catch dynamically added elements. The fix is usually `hx-swap="outerHTML"` and ensuring Alpine runs after HTMX completes.

**CSS variables for theming are great until you want to theme an SVG.** The Bitcoin chart's gradient uses `hsl(var(--primary))` which works fine, but SVG doesn't inherit CSS custom properties the way HTML elements do. Needed explicit styling.

## The Numbers

| Metric | Before (janky JS) | After (HTMX + Alpine) |
|--------|-------------------|----------------------|
| JS size | ~50KB (bundled) | ~29KB (two CDN scripts) |
| Build time | N/A (no build) | N/A (still no build) |
| Time to interactive | ~2s | ~800ms |
| Lines of JavaScript I wrote | ~500 | ~50 |
| Developer satisfaction | "it works" | "this is actually fun" |

## The Conclusion

If you're building a dashboard, an admin panel, or any content-heavy application where the server already knows what to render, consider HTMX. Not because it's trendy. Because it removes complexity instead of adding it.

The dashboard is now running on a Raspberry Pi 5 (odesa.local:8080), serving HTML fragments to my iPad, updating every 60 seconds, and using less CPU than a single Chrome tab.

Sometimes the simple answer is the right answer. Even if it doesn't make for a good conference talk.

---

*Built with Flask, HTMX, Alpine.js, and a healthy disregard for JavaScript frameworks. Deployed via Ansible to a Pi 5 running 24/7.*