async function loadStats(){
    const res = await fetch('/admin/api/stats');
    const data = await res.json();
    document.getElementById('userCount').innerText = data.userCount;
    document.getElementById('orderCount').innerText = data.orderCount;
    document.getElementById('salesThisMonth').innerText = data.salesThisMonth;
}

async function loadUsers(){
    const res = await fetch('/admin/api/users');
    const data = await res.json();
    const tbody = document.querySelector('#usersTable tbody');
    tbody.innerHTML = '';
    data.forEach(u => {
        const tr = document.createElement('tr');
        tr.innerHTML = `<td>${u.id}</td><td>${u.name}</td><td>${u.email}</td>`;
        tbody.appendChild(tr);
    });
}

async function loadOrders(){
    const res = await fetch('/admin/api/orders-summary');
    const data = await res.json();
    const tbody = document.querySelector('#ordersTable tbody');
    tbody.innerHTML = '';
    data.forEach(o => {
        const tr = document.createElement('tr');
        tr.innerHTML = `<td>${o.id}</td><td>${o.userName}</td><td>${translateStatus(o.status)}</td><td>${formatCurrency(o.totalPrice)}</td>`;
        tbody.appendChild(tr);
    });
}

window.addEventListener('load', () => {
    loadStats();
    loadUsers();
    loadOrders();
});

async function loadCharts(){
    // revenue
    try{
        const r = await fetch('/admin/api/revenue-months');
        const d = await r.json();
        const ctx = document.getElementById('revenueChart').getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: { labels: d.labels, datasets: [{ label: 'Doanh thu', data: d.data, borderColor: '#0d6efd', backgroundColor: 'rgba(13,110,253,0.1)'}] },
            options: { responsive:true }
        });
    }catch(e){ console.warn('No revenue data', e); }

    // top products
    try{
        const r2 = await fetch('/admin/api/top-products');
        const t = await r2.json();
        const ctx2 = document.getElementById('topProductsChart').getContext('2d');
        new Chart(ctx2, { type: 'bar', data: { labels: t.labels, datasets:[{label:'Số lượng', data:t.data, backgroundColor:'#ffc107'}] }, options:{responsive:true} });
    }catch(e){ console.warn('No top-products data', e); }
}

window.addEventListener('load', () => {
    // charts may load after other widgets
    setTimeout(loadCharts, 300);
});

// Small UI helpers
function formatCurrency(v){
    try{ return new Intl.NumberFormat('vi-VN',{style:'currency',currency:'VND'}).format(v); }catch(e){return v}
}

// Map values to Vietnamese labels where useful
function translateStatus(s){
    return ({'pending':'Chờ xử lý','processing':'Đang xử lý','shipped':'Đang gửi','completed':'Hoàn thành','cancelled':'Đã hủy','delivered':'Đã giao'}[s]||s);
}
