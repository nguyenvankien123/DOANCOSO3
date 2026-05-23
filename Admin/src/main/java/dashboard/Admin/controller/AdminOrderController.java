package dashboard.admin.controller;

import dashboard.admin.entity.Order;
import dashboard.admin.repository.OrderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/orders")
public class AdminOrderController {

    @Autowired
    private OrderRepository orderRepository;

    @GetMapping
    public String list(Model model) {
        model.addAttribute("orders", orderRepository.findAll());
        return "admin/orders";
    }

    @GetMapping("/{id}/edit")
    public String edit(@PathVariable Long id, Model model) {
        model.addAttribute("order", orderRepository.findById(id).orElse(new Order()));
        return "admin/order-form";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute Order order) {
        orderRepository.save(order);
        return "redirect:/admin/orders";
    }

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable Long id) {
        orderRepository.deleteById(id);
        return "redirect:/admin/orders";
    }
}
