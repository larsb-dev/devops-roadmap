# GitHub Pages Deployment

## Links

### Repository

https://github.com/larsb-dev/gh-deployment-workflow

- I had to of course create a seperate repo, because it would've been a mess and lead to issues if I created the project in a subfolder inside the devops-projects repository
- Actually, I don't even know what would happen if you had a repo within a repo?

### Live URl

https://larsb-dev.github.io/gh-deployment-workflow/

###

- Just an `index.html` page deployed automatically to GitHub pages

## Issues

### Vite Asset Bundling

```html
<script type="module" src="/src/main.js"></script>
```

- Vite pipeline needs to import CSS via JavaScript

### Change Base URL

```javascript
export default defineConfig({
  base: '/gh-deployment-workflow/',
  plugins: [tailwindcss()],
});
```

- This will insert the repostory name in the URL which is necessary for the assets to be loaded correctly

```
❌ Bad
https://larsb-dev.github.io/assets/index-COAvK7aG.css

✅ Good
https:////larsb-dev.github.io/gh-deployment-workflow/assets/favicon.17e50649.svg
```

## Aside

I don't really feel comfortable with GitHub actions, because I haven't really learned it properly. I'm copying from other files and guess what it does. I want to learn more about its intricacies.

## Resources

- [Deploy Vite app to GitHub Pages using GitHub Actions](https://github.com/sitek94/vite-deploy-demo)
