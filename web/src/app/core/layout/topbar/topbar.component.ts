import { Component, Output, EventEmitter, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-topbar',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './topbar.component.html',
  styleUrls: ['./topbar.component.css']
})
export class TopbarComponent {
  @Output() toggleNav = new EventEmitter<void>();

  authService = inject(AuthService);
  currentUser = this.authService.currentUser;

  onToggleNav(): void {
    this.toggleNav.emit();
  }

  onLogout(): void {
    this.authService.logout().subscribe();
  }
}
