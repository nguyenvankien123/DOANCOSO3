package dashboard.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AdminController {

    @GetMapping("/admin")
    public String dashboard(Model model) {
        // Placeholder values; front-end will fetch real data via APIs
        model.addAttribute("userCount", 0);
        model.addAttribute("orderCount", 0);
        model.addAttribute("inventoryCount", 0);
        model.addAttribute("salesThisMonth", 0);
        return "admin/dashboard";
    }

}
