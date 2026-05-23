package dashboard.admin.controller;

import dashboard.admin.entity.Product;
import dashboard.admin.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/products")
public class AdminProductController {

    @Autowired
    private ProductRepository productRepository;

    @GetMapping
    public String list(Model model) {
        model.addAttribute("products", productRepository.findAll());
        return "admin/products";
    }

    @GetMapping("/new")
    public String createForm(Model model) {
        model.addAttribute("product", new Product());
        return "admin/product-form";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute Product product) {
        productRepository.save(product);
        return "redirect:/admin/products";
    }

    @GetMapping("/{id}/edit")
    public String edit(@PathVariable Long id, Model model) {
        model.addAttribute("product", productRepository.findById(id).orElse(new Product()));
        return "admin/product-form";
    }

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable Long id) {
        productRepository.deleteById(id);
        return "redirect:/admin/products";
    }
}
