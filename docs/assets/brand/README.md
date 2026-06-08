# Layerhouse Grid Store Brand Theme

Selected direction: `G. Grid Store`.

## Concept

Layerhouse is represented as a house-shaped repository grid. The roof gives the name an immediate physical anchor. The grid bays represent repositories, image layers, charts, and stored artifacts. The cyan bay marks the active object: selected repository, leader node, or current operation.

This replaces the previous ornamental mark. The new identity should read as infrastructure, storage, and operations before it reads as decorative brand art.

## Light Theme

Primary surfaces:

- Background: `#ffffff`
- App background: `#f7fafc`
- Border: `rgba(15,23,42,.10)`
- Text: `#172033`
- Muted text: `#64748b`

Mark:

- Shell gradient: `#27364c` to `#111827`
- Roof gradient: `#334155` to `#172033`
- Light bay: `#e2e8f0`
- Mid bay: `#94a3b8`
- Dark bay: `#64748b`
- Wide bay: `#cbd5e1`
- Active bay: `#7dd3fc` to `#0ea5e9`

## Dark Theme

Primary surfaces:

- Background: `#07111f` to `#111827`
- Border: `rgba(226,232,240,.12)`
- Text: `#f8fafc`
- Muted text: `#94a3b8`

Mark:

- Shell gradient: `#f8fafc` to `#cbd5e1`
- Roof gradient: `#ffffff` to `#dbe7f5`
- Dark bay: `#1e293b`
- Mid bay: `#475569`
- Secondary bay: `#64748b`
- Wide bay: `#334155`
- Active bay: `#67e8f9` to `#38bdf8`

## Typography

Use `Inter` by default. `Satoshi` is a compatible brand option if available, but do not introduce it as a runtime dependency for the dashboard unless the project already bundles it.

- Wordmark weight: 830
- Product label / tagline weight: 760
- Letter spacing: `0`

## Usage

- Use the mark alone for favicon, sidebar compact mode, CLI docs, and Helm chart icon.
- Use the lockup in README, docs landing page, release pages, and dashboard login/empty states.
- Do not place the mark inside a rounded app-icon tile unless the surrounding platform requires it.
- The cyan active bay should stay on the right edge. It gives the grid a stable asymmetry and helps the icon survive small sizes.

## International Naming

Keep `Layerhouse` as the primary global brand. The canonical English product title is `Layerhouse OCI Container Registry` with no separator. Localized display titles may use ` · ` between the display name and descriptor where the alias plus category needs visual separation. Avoid hyphens, dashes, and colons for brand lockups.

Use cultural aliases only where they reduce reading burden or make the name easier to discuss locally. Compact UI surfaces should use the display name only; keep category descriptors out of the topbar and other constrained controls. Do not translate package names, binary names, image names, repository paths, or command names.

| Locale | Display name | Reading / alias | Descriptor |
| --- | --- | --- | --- |
| Global / en | `Layerhouse` | - | OCI container registry |
| zh-CN | `Layerhouse（层藏）` | cengcang | OCI 容器镜像仓库 |
| zh-TW / zh-HK | `Layerhouse（層藏）` | cengcang | OCI 容器映像倉庫 |
| ja-JP | `Layerhouse（層蔵）` | そうぞう | OCI コンテナレジストリ |
| ko-KR | `Layerhouse（레이어하우스）` | reieohauseu | OCI 컨테이너 레지스트리 |
| vi-VN | `Layerhouse` | - | Kho OCI image container |

## Files

- `layerhouse-mark-light.svg`
- `layerhouse-mark-dark.svg`
- `layerhouse-lockup-light.svg`
- `layerhouse-lockup-dark.svg`
